//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 30.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let items: [String : ToDoItem]
    var sortedArray = [ToDoItem]()
    let fileCache = FileCache()
    
    var completedCount = -3
    var showIsOn = false
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let imageCheckSwipe = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemGreen, .white]))
    
    let imageInfo = UIImage(
        systemName: "info.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [UIColor(named: "GrayLight") ?? .gray, UIColor(named: "White") ?? .white]))
    
    let imageTrash = UIImage(
        systemName: "trash.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [UIColor(named: "White") ?? .white]))
    
    let imageEmpty = UIImage(
        systemName: "trash.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.clear]))
    
    let imageUncheckSwipe = UIImage(
        systemName: "x.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .systemRed]))
    
    init(items: [String: ToDoItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
        let values = Array(items.values)
        let sortedValues = values.sorted { $0.creationDate > $1.creationDate }
        sortedArray = sortedValues.map { $0 }
        print(sortedArray)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileCache.loadFromFile(from: "testFile")
        print(fileCache.items)
        
        completedCount = items.values.filter { $0.isDone }.count

        title = "Мои дела"
        view.backgroundColor = UIColor(named: "BackPrimary")
        tableView.backgroundColor = nil
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        view.addSubview(tableView)
        view.addSubview(floatingButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        floatingButtonSetup()
        headerSetup()
        
        let currentMargins = navigationController?.navigationBar.layoutMargins
        let tableViewLeading = 16
        let tableViewHeaderLeading = 16
        let leftMargin = tableViewLeading + tableViewHeaderLeading
        let newMargins = UIEdgeInsets(top: currentMargins?.top ?? 0.0, left: CGFloat(leftMargin), bottom: currentMargins?.bottom ?? 0.0, right: currentMargins?.right ?? 0.0)
        
        navigationController?.navigationBar.layoutMargins = newMargins
        
    }
    
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 60,
                                            height: 60))
        
        button.backgroundColor = UIColor(named: "Blue")
        button.tintColor = .white
        
        let image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 32,
                weight: .medium))
        
        button.setImage(image, for: .normal)
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    private func floatingButtonSetup() {
        
        floatingButton.widthAnchor.constraint(
            equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(
            equalToConstant: 50).isActive = true
        floatingButton.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor).isActive = true
        floatingButton.bottomAnchor.constraint(
            equalTo: self.view.layoutMarginsGuide.bottomAnchor,
            constant: -10).isActive = true
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        floatingButton.addTarget(self, action: #selector(newTaskCreate), for: .touchUpInside)
    }
    
    @objc func newTaskCreate() {
        let viewController = DetailsViewController(openType: .add, item: nil)
        
        viewController.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate in
            
            let item = ToDoItem(id: id, text: taskText, importance: importance, deadline: deadline, creationDate: createDate)
            self.sortedArray.insert(item, at: 0)
            self.tableView.reloadData()
            let _ = self.fileCache.add(item: item)
            print(self.fileCache.items)
            self.fileCache.saveToFile(to: "testFile")
            
        }
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true)
    }
    
    func oldTaskEdit(item: ToDoItem) {
        let viewController: UIViewController = DetailsViewController(openType: .edit, item: item)
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true)
    }
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = UIColor(named: "LabelTertiary")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let showButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(UIColor(named: "Blue"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func headerSetup() {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width,
                                          height: 40))
        
        countLabel.text = "Выполнено — \(completedCount)"
        header.addSubview(countLabel)
        header.addSubview(showButton)
        
        showButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        
        
        countLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 32).isActive = true
        countLabel.widthAnchor.constraint(lessThanOrEqualToConstant: header.frame.width/2).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        
        showButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -32).isActive = true
        showButton.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        showButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
        if showIsOn {
            showButton.setTitle("Скрыть", for: .normal)
        } else {
            showButton.setTitle("Показать", for: .normal)
        }
        tableView.tableHeaderView = header
        
    }
    
    @objc func showButtonTapped() {
        showIsOn = !showIsOn
        if showIsOn {
            showButton.setTitle("Скрыть", for: .normal)
        } else {
            showButton.setTitle("Показать", for: .normal)
        }
        view.layoutIfNeeded()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
        //cell.contentView.frame.size = CGSize(width: tableView.frame.width, height: 70)
        
        cell.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 16)
        cell.textLabel?.numberOfLines = 3
        if indexPath.row == sortedArray.count {
            cell.textLabel?.text = "Новое"
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .light)
            cell.textLabel?.textColor = UIColor(named: "LabelTertiary")
            cell.imageView?.image = imageEmpty
            cell.accessoryView = nil
        } else {
            cell.textLabel?.text = sortedArray[indexPath.row].text
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .light)
            cell.textLabel?.textColor = UIColor(named: "LabelPrimary")
            let circleImage = UIImage(named: "emptyCircle")
            cell.imageView?.image = circleImage
            let arrowImageView = UIImageView(image: UIImage(named: "transit"))
            cell.accessoryView = arrowImageView
            
            if sortedArray[indexPath.row].isDone {
                cell.imageView?.image = UIImage(named: "doneCircle")
            } else {
                cell.imageView?.image = UIImage(named: "emptyCircle")
            }
            let constraint1 = cell.contentView.heightAnchor.constraint(equalToConstant: 0)
            constraint1.priority = .defaultLow
            let constraint2 = cell.heightAnchor.constraint(equalToConstant: 56)
            constraint2.priority = .defaultLow
        }
        
        cell.backgroundColor = UIColor(named: "BackSecondary")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == sortedArray.count {
            newTaskCreate()
        } else {
            let vc = DetailsViewController(openType: .edit, item: sortedArray[indexPath.row])
            vc.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate in
                
                self.sortedArray.remove(at: indexPath.row)
                let item = ToDoItem(id: id, text: taskText, importance: importance, deadline: deadline, isDone: completed, creationDate: createDate)
                self.sortedArray.insert(item, at: indexPath.row)
                let _ = self.fileCache.add(item: item)
                print(self.fileCache.items)
                self.fileCache.saveToFile(to: "testFile")
                tableView.reloadRows(at: [indexPath], with: .none)
                
            }
            
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath)
        guard indexPath.row != sortedArray.count else {
            return nil
        }
        let item = sortedArray[indexPath.row]
        let isDone = item.isDone
        
        let action = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            var itemDone = false
            if !isDone {
                cell?.imageView?.image = UIImage(named: "doneCircle")
                itemDone = true
                self.completedCount += 1
            } else {
                cell?.imageView?.image = UIImage(named: "emptyCircle")
                itemDone = false
                self.completedCount -= 1
            }
            let newItem = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, isDone: itemDone, creationDate: item.creationDate, changedDate: item.changedDate)
            self.headerSetup()
            self.sortedArray[indexPath.row] = newItem
            let _ = self.fileCache.add(item: newItem)
            self.fileCache.saveToFile(to: "testFile")
            completionHandler(true)
        }
        if !isDone {
            action.backgroundColor = UIColor(named: "Green")
            action.image = imageCheckSwipe
        } else {
            action.backgroundColor = UIColor(named: "GrayLight")
            action.image = imageUncheckSwipe
            headerSetup()
        }
        
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row != sortedArray.count else {
            return nil
        }
        let item = sortedArray[indexPath.row]
        let detailsAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            
            let vc = DetailsViewController(openType: .edit, item: self.sortedArray[indexPath.row])
            vc.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate in
                
                self.sortedArray.remove(at: indexPath.row)
                let item = ToDoItem(id: id, text: taskText, importance: importance, deadline: deadline, isDone: completed, creationDate: createDate)
                self.sortedArray.insert(item, at: indexPath.row)
                let _ = self.fileCache.add(item: item)
                print(self.fileCache.items)
                self.fileCache.saveToFile(to: "testFile")
                tableView.reloadRows(at: [indexPath], with: .none)
                
            }
            let navVC = UINavigationController(rootViewController: vc)
            self.present(navVC, animated: true)
            completionHandler(true)
        }
        detailsAction.backgroundColor = UIColor(named: "GrayLight")
        detailsAction.image = imageInfo
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            
            if self.sortedArray[indexPath.row].isDone {
                self.completedCount -= 1
                self.headerSetup()
            }
            
            tableView.beginUpdates()
            self.sortedArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            let _ = self.fileCache.remove(at: item.id)
            self.fileCache.saveToFile(to: "testFile")
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Red")
        deleteAction.image = imageTrash
        
        return UISwipeActionsConfiguration(actions: [deleteAction, detailsAction])
    }
}
