//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев
//

import Foundation
import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        data.count
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Cell\(indexPath.row + 1)"
        return cell
    }
    
    
    var data: [ToDoItem] = []
    var file = FileCache()
    let cellsTableView = UITableView()
    let setupButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cellsTableView)
        //        self.navigationItem.title = "Your Title"
        cellsTableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "cell")
        cellsTableView.dataSource = self
        cellsTableView.delegate = self
        
        setupCellsTableView()
        setupButtonTapped()
        configureNavigationBar()
        
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 247 / 255, green: 246 / 255, blue: 242 / 255, alpha: 1)]
        
        navigationItem.title = "Мои дела"
        
        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.backgroundColor = UIColor(red: 247 / 255, green: 246 / 255, blue: 242 / 255, alpha: 1)
        compactAppearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        
        self.navigationController?.navigationBar.standardAppearance = compactAppearance
        self.navigationController?.navigationBar.compactAppearance = compactAppearance
        
        let largeAppearance = UINavigationBarAppearance()
        largeAppearance.backgroundColor = UIColor(red: 247 / 255, green: 246 / 255, blue: 242 / 255, alpha: 1)
        compactAppearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        largeAppearance.shadowColor = .clear
        self.navigationController?.navigationBar.scrollEdgeAppearance = largeAppearance
    }
    
    func setupCellsTableView(){
        
        
        
        cellsTableView.translatesAutoresizingMaskIntoConstraints = false
        cellsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cellsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cellsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cellsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
    //     self.data[indexPath.row]
    
    
    func setupButtonTapped(){
        setupButton.frame = CGRect(x: 170, y: 714, width: 44, height: 44)
        setupButton.layer.cornerRadius = 0.5 * setupButton.bounds.size.width
        setupButton.setTitle("+", for: .normal)
        //        setupButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        setupButton.backgroundColor = .blue
        setupButton.addTarget(self, action: #selector(openSetup), for: .touchUpInside)
        view.addSubview(setupButton)
    }
    
    @objc func openSetup() {
        let setupVC = SetupViewController()
        let navController = UINavigationController(rootViewController: setupVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true, completion: nil)
    }
    
    //    ===============
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionInfo = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            completionHandler(true)
        }
        actionInfo.image = UIImage(systemName: "info.circle.fill")
        actionInfo.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)
        
        let actionRemove = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            let id = self.data[indexPath.row].id
            self.file.remove(id)
            try? self.file.save(to: "ToDoItem")
            self.data = self.file.items.values.filter { $0.isDone == false }
            self.cellsTableView.reloadData()
            completionHandler(true)
        }
        actionRemove.image = UIImage(systemName: "trash")
        actionRemove.backgroundColor = UIColor(red: 1, green: 0.23, blue: 0.19, alpha: 1)
        return UISwipeActionsConfiguration(actions: [actionRemove, actionInfo])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDone = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            let id = self.data[indexPath.row].id
            //            self.file.completedTask(id: id)
            try? self.file.save(to: "ToDoItem")
            self.data = self.file.items.values.filter { $0.isDone == false }
            self.cellsTableView.reloadData()
            completionHandler(true)
        }
        actionDone.image = UIImage(systemName: "checkmark.circle")
        actionDone.backgroundColor = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)
        return UISwipeActionsConfiguration(actions: [actionDone])
    }
}
//  ================
    

    
    
    
    
    
    
    
    
    
    
    
    
    //extension ViewController: UITableViewDataSource {
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return data.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        guard
    //            let cell = tableView.dequeueReusableCell(
    //                withIdentifier: "cell",
    //                for: indexPath
    //            ) //as? TodoListItemCell
    //        else {
    //            return UITableViewCell()
    //        }
    //
    //        cell.configure(
    //            with: TodoItemCellViewModel(item: data[indexPath.row])
    //        )
    //
    //        return cell
    //    }
    //}
    
    //extension ViewController: UITableViewDataSource {
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        cellsTableView.deselectRow(at: indexPath, animated: true)
    //        print("Cell tapped")
    //    }
    //
    ////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    ////        return 30
    ////    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    //        cell.textLabel?.text = "Cell\(indexPath.row + 1)"
    //        return cell
    //    }
    //
    
    
    
    
    
    //    // Возвращает количество строк в секции
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // Здесь вместо "data" нужно указать ваш массив или список данных
    //        return data.count
    //    }
    //
    //    // Создает и возвращает ячейку для определенного местоположения в таблице
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    //        let toDoItem = ToDoItem[indexPath.row]
    //        cell.textLabel?.text = toDoItem.title
    //        // можно использовать isDone для отображения состояния задачи
    //
    //        return cell
    //    }
    //}
    
    
    
    
    
    
    

        
        
        
        
        
        //
        //    @objc func openSetup() {
        //        let setupVC = SetupViewController()
        //        setupVC.modalPresentationStyle = .pageSheet
        //        present(setupVC, animated: true, completion: nil)
        //    }
        

        
        

    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    //class ViewController: UIViewController {
    //
    //    let importanceControl = UISegmentedControl(items: Importance.allCases.map { $0.rawValue })
    //    let noteTextView = UITextView()
    //    let saveButton = UIButton()
    //    let deleteButton = UIButton()
    //    let datePicker = UIDatePicker()
    //    let scrollView = UIScrollView()
    //    let contentView = UIView()
    //
    //    var todoItem: ToDoItem?
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        setupUI()
    //    }
    //
    //    private func setupUI() {
    //        // Задаем размеры и положение элементов UI
    //        // и добавляем их на нашу вью
    //        // ...
    //        // scrollView
    //        self.view.addSubview(scrollView)
    //        scrollView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
    //            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    //            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    //            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    //        ])
    //
    //        scrollView.addSubview(contentView)
    //        contentView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
    //            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
    //            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
    //            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    //            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    //        ])
    //
    //        // importanceControl
    //        // noteTextView
    //        // saveButton
    //        // deleteButton
    //        // datePicker
    //
    //        // Добавляем события для кнопок
    //        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    //        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    //
    //        // Загружаем данные, если они есть
    //        loadTodoItem()
    //    }
    //
    //    @objc private func saveButtonTapped() {
    //        // Здесь вы должны сохранить данные из интерфейса в модель
    //        // и затем сохранить модель в вашем выбранном постоянном хранилище
    //    }
    //
    //    @objc private func deleteButtonTapped() {
    //        // Здесь вы должны удалить модель из вашего выбранного постоянного хранилища
    //    }
    //
    //    private func loadTodoItem() {
    //        // Здесь вы должны загрузить модель из вашего выбранного постоянного хранилища
    //        // и заполнить интерфейс данными из модели
    //    }
    //}
    //
    //
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //import Foundation
    //import UIKit
    //
    //class ViewController: UIViewController {
    //
    //    var itemNameLabel: UILabel {
    //        let lbl = UILabel(frame: CGRect(x: 160, y: 60, width: 43, height: 22))
    //        lbl.text = "Delo"
    //        lbl.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    //        lbl.textColor = UIColor.black
    //        lbl.textAlignment = NSTextAlignment.center
    //        return lbl
    //    }
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        view.addSubview(itemNameLabel)
    //
    //    }
    //}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    extension ViewController: UITableViewController {
    //
    //
    //
    //    }
    
    
    //    let scrollView = UIScrollView()
    //    let contentView = UIView()
    //    let textField = UITextField()
    //    let importanceSegmentedControl = UISegmentedControl(items: Importance.allCases.map { $0.rawValue })
    //    let deadlinePicker = UIDatePicker()
    //    let isDoneSwitch = UISwitch()
    //    let saveButton = UIButton(type: .system)
    //    let deleteButton = UIButton(type: .system)
    //
    //    var toDoItem: ToDoItem?
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        setupUI()
    //        loadToDoItem()
    //    }
    //
    //    func setupUI() {
    //        view.addSubview(scrollView)
    //        scrollView.addSubview(contentView)
    //
    //        // Configure UIScrollView
    //        scrollView.frame = view.bounds
    //        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //
    //        // Configure ContentView
    //        contentView.frame = scrollView.bounds
    //        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //
    //        // Configure SaveButton
    //        saveButton.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
    //        saveButton.setTitle("Сохранить", for: .normal)
    //        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    //        contentView.addSubview(saveButton)
    //
    //        // Configure DeleteButton
    //        deleteButton.frame = CGRect(x: (contentView.frame.width - 100) / 2, y: contentView.frame.height - 70, width: 100, height: 50)
    //        deleteButton.setTitle("Удалить", for: .normal)
    //        contentView.addSubview(deleteButton)
    //
    //        // Configure TextField
    //        textField.frame = CGRect(x: 16, y: 72, width: 343, height: 120)
    //        textField.borderStyle = .roundedRect
    //        contentView.addSubview(textField)
    //
    //        // Configure ImportanceSegmentedControl
    //        importanceSegmentedControl.frame = CGRect(x: 20, y: textField.frame.maxY + 20, width: contentView.frame.width - 40, height: 30)
    //        contentView.addSubview(importanceSegmentedControl)
    //
    //        // Configure DatePicker
    //        deadlinePicker.frame = CGRect(x: 20, y: importanceSegmentedControl.frame.maxY + 20, width: contentView.frame.width - 40, height: 200)
    //        contentView.addSubview(deadlinePicker)
    //
    //        // Configure isDoneSwitch
    //        isDoneSwitch.frame = CGRect(x: 20, y: deadlinePicker.frame.maxY + 20, width: 50, height: 30)
    //        contentView.addSubview(isDoneSwitch)
    //
    //
    //
    //        // Resize the contentView to fit the content
    //        contentView.frame.size.height = deleteButton.frame.maxY + 20
    //        scrollView.contentSize = contentView.frame.size
    //    }
    //
    //    func loadToDoItem() {
    //        // Загружаем данные ToDoItem в UI элементы здесь
    //    }
    //
    //    @objc func saveButtonTapped() {
    //        // Сохраняем данные из UI элементов в
    //    }
    //
    //}
    
