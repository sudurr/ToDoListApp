

import Foundation
import CocoaLumberjackSwift

@MainActor
final class TodoListViewModel: TodoListViewOutput {

    var completedItemsCountUpdated: ((Int) -> Void)?
    var todoListUpdated: (([TodoItemTableViewCell.DisplayData]) -> Void)?
    var errorOccurred: ((String) -> Void)?
    var updateActivityIndicatorState: ((Bool) -> Void)?

    // MARK: - Private Properties

    private var completedAreShown: Bool = false
    private var completedItemsCount: Int = 0
    private var todoList: [TodoItem] = []

    private lazy var cacheFileName = "cache"
    private let networkService: NetworkService
    private let fileCache: FileCache
    private let dateService: DateService
    private weak var coordinator: TodoListCoordinator?

    init(
        networkService: NetworkService,
        fileCache: FileCache,
        dateService: DateService,
        coordinator: TodoListCoordinator
    ) {
        self.networkService = networkService
        self.fileCache = fileCache
        self.dateService = dateService
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func viewDidLoad() {
        Task(priority: .userInitiated) {
            await loadDataFromLocalStorage()
            sendData()

            handleActivityIndicator(by: true)
            networkService.incrementNumberOfTasks()
            if fileCache.isDirty {
                syncTodoList()
            } else {
                loadTodoList()
            }
        }
    }

    func changedCompletedAreShownValue(newValue: Bool) {
        completedAreShown = newValue
        sendData()
    }

    func toggleIsDoneValue(for id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        let newItem = getUpdatedItem(for: item, newIsDoneValue: item.isDone ? false : true)
        updateItemInCache(newItem)
        sendData()
        saveDataToLocalStorage()

        handleActivityIndicator(by: true)
        networkService.incrementNumberOfTasks()
        if fileCache.isDirty {
            syncTodoList()
        } else {
            changeTodoItem(newItem)
        }
    }

    func deleteItem(with id: UUID) {
        deleteFromCacheItem(with: id)
        sendData()
        saveDataToLocalStorage()

        handleActivityIndicator(by: true)
        networkService.incrementNumberOfTasks()
        if fileCache.isDirty {
            syncTodoList()
        } else {
            deleteTodoItem(with: id)
        }
    }

    func didSelectItem(with id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        coordinator?.openDetails(of: item, delegate: self)
    }

    func didTapAdd() {
        coordinator?.openCreationOfTodoItem(delegate: self)
    }

    // MARK: - Private Methods

    private func sendData() {
        var itemsToDisplay: [TodoItem] = []
        if completedAreShown {
            itemsToDisplay = todoList
        } else {
            itemsToDisplay = todoList.filter({ $0.isDone == false })
        }
        if let todoListLoaded = todoListUpdated {
            let displayData: [TodoItemTableViewCell.DisplayData] = mapData(items: itemsToDisplay)
            todoListLoaded(displayData)
        }
        if let completedItemsCountChanged = completedItemsCountUpdated {
            completedItemsCountChanged(completedItemsCount)
        }
    }

    private func updateData(with newList: [TodoItem]) {
        todoList = newList
        todoList.sort(by: { $0.creationDate > $1.creationDate })
        completedItemsCount = todoList.filter({ $0.isDone == true }).count
    }

    private func getUpdatedItem(for item: TodoItem, newIsDoneValue: Bool) -> TodoItem {
        TodoItem(
            id: item.id,
            text: item.text,
            importance: item.importance,
            deadline: item.deadline,
            isDone: newIsDoneValue,
            creationDate: item.creationDate,
            modificationDate: Date(),
            textColor: item.textColor
        )
    }

    private func mapData(items: [TodoItem]) -> [TodoItemTableViewCell.DisplayData] {
        items.map { item in
            TodoItemTableViewCell.DisplayData(
                id: item.id,
                text: item.text,
                importance: item.importance,
                deadline: dateService.getString(from: item.deadline),
                isDone: item.isDone
            )
        }
    }

    private func handleActivityIndicator(by state: Bool) {
        if networkService.numberOfTasks == 0,
           let updateActivityIndicatorState = updateActivityIndicatorState {
            updateActivityIndicatorState(state)
        }
    }

}

// MARK: - TodoItemViewModelDelegate

extension TodoListViewModel: TodoItemViewModelDelegate {

    func saveToCacheTodoItem(_ newItem: TodoItem) {
        updateItemInCache(newItem)
        sendData()
        saveDataToLocalStorage()
    }

    func deleteFromCacheTodoItem(with id: UUID) {
        deleteFromCacheItem(with: id)
        sendData()
        saveDataToLocalStorage()
    }

    func saveToServerTodoItem(_ newItem: TodoItem, isNewItem: Bool) {
        handleActivityIndicator(by: true)
        networkService.incrementNumberOfTasks()
        if fileCache.isDirty {
            syncTodoList()
        } else if isNewItem {
            addTodoItem(newItem)
        } else {
            changeTodoItem(newItem)
        }
    }

    func deleteFromServerTodoItem(with id: UUID) {
        handleActivityIndicator(by: true)
        networkService.incrementNumberOfTasks()
        if fileCache.isDirty {
            syncTodoList()
        } else {
            deleteTodoItem(with: id)
        }
    }

}

// MARK: - Networking

extension TodoListViewModel {

    private func loadTodoList() {
        DDLogInfo(#function)
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                let todoList = try await self.networkService.loadTodoList()
                self.updateCache(with: todoList)
                self.sendData()
                self.saveDataToLocalStorage()
            } catch {
                DDLogError("\(#function): \(error.localizedDescription)")
                if let errorOccurred = self.errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
            self.networkService.decrementNumberOfTasks()
            self.handleActivityIndicator(by: false)
        }
    }

    private func syncTodoList() {
        DDLogInfo(#function)
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                let todoList = try await self.networkService.syncTodoList(todoList)
                self.updateCache(with: todoList)
                self.sendData()
                self.saveDataToLocalStorage()
                self.fileCache.updateIsDirtyValue(by: false)
            } catch {
                DDLogError("\(#function): \(error.localizedDescription)")
                if let errorOccurred = self.errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
            self.networkService.decrementNumberOfTasks()
            self.handleActivityIndicator(by: false)
        }
    }

    private func changeTodoItem(_ item: TodoItem, retryDelay: Int = DelayingTime.minTime) {
        DDLogInfo(#function)
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.networkService.changeTodoItem(item)
                self.networkService.decrementNumberOfTasks()
                self.handleActivityIndicator(by: false)
            } catch {
                DDLogError("\(#function): \(error.localizedDescription)")
                if retryDelay < DelayingTime.maxTime,
                   let requestError = error as? RequestError,
                   case .serverError = requestError {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(retryDelay)) {
                        self.changeTodoItem(item, retryDelay: DelayingTime.calculateNextDelay(from: retryDelay))
                    }
                } else {
                    self.fileCache.updateIsDirtyValue(by: true)
                    self.syncTodoList()
                }
            }
        }
    }

    private func addTodoItem(_ item: TodoItem, retryDelay: Int = DelayingTime.minTime) {
        DDLogInfo(#function)
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.networkService.addTodoItem(item)
                self.networkService.decrementNumberOfTasks()
                self.handleActivityIndicator(by: false)
            } catch {
                DDLogError("\(#function): \(error.localizedDescription)")
                if retryDelay < DelayingTime.maxTime,
                   let requestError = error as? RequestError,
                   case .serverError = requestError {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(retryDelay)) {
                        self.changeTodoItem(item, retryDelay: DelayingTime.calculateNextDelay(from: retryDelay))
                    }
                } else {
                    self.fileCache.updateIsDirtyValue(by: true)
                    self.syncTodoList()
                }
            }
        }
    }

    private func deleteTodoItem(with id: UUID, retryDelay: Int = DelayingTime.minTime) {
        DDLogInfo(#function)
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.networkService.deleteTodoItem(id: id.uuidString)
                self.networkService.decrementNumberOfTasks()
                self.handleActivityIndicator(by: false)
            } catch {
                DDLogError("\(#function): \(error.localizedDescription)")
                if retryDelay < DelayingTime.maxTime,
                   let requestError = error as? RequestError,
                   case .serverError = requestError {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(retryDelay)) {
                        self.deleteTodoItem(with: id, retryDelay: DelayingTime.calculateNextDelay(from: retryDelay))
                    }
                } else {
                    self.fileCache.updateIsDirtyValue(by: true)
                    self.syncTodoList()
                }
            }
        }
    }

}

// MARK: - Caching

extension TodoListViewModel {

    private func updateItemInCache(_ item: TodoItem) {
        fileCache.addItem(item)
        updateData(with: Array(fileCache.todoItems.values))
    }

    private func deleteFromCacheItem(with id: UUID) {
        fileCache.deleteItem(with: id)
        updateData(with: Array(fileCache.todoItems.values))
    }

    private func updateCache(with todoList: [TodoItem]) {
        fileCache.todoItems.keys.forEach(fileCache.deleteItem(with:))
        todoList.forEach(self.fileCache.addItem(_:))
        updateData(with: todoList)
    }

    private func saveDataToLocalStorage() {
        Task(priority: .utility) {
            do {
                try await self.fileCache.saveItemsToJSON(fileName: cacheFileName)
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }

    private func loadDataFromLocalStorage() async {
        do {
            try await fileCache.loadItemsFromJSON(fileName: cacheFileName)
            updateData(with: Array(fileCache.todoItems.values))
        } catch {
            DDLogError(error.localizedDescription)
        }
    }

}
