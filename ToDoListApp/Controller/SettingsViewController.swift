



///
////  SettingsViewController.swift
////  ToDoListApp
////
////  Created by Судур Сугунушев on 25.06.2023.
////
//
//import Foundation
//import UIKit
//
//class SettingsViewController: UIViewController {
//    
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//    let customNavBar = UINavigationBar()
//    let textField = UITextField()
//    let importanceField = UIStackView()
//    let importanceSegmentedControl = UISegmentedControl(items: Importance.allCases.map { $0.rawValue })
//    let deadlinePicker = UIDatePicker()
//    let isDoneSwitch = UISwitch()
//    let cancelButton = UIButton(type: .system)
//    let saveButton = UIButton(type: .system)
//    let deleteButton = UIButton(type: .system)
//    
//    let titleLabel = UILabel()
//    
//    let importanceLabel = UILabel()
//    let importanceControl = UISegmentedControl()
//    var importanceView = UIView()
//    
//    
//    
//    var toDoItem: ToDoItem?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupCustomNavigationBar()
//        setupTextField()
//        setupSegmentedControl()
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
//        scrollView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
//        
//        // Configure ContentView
//        contentView.frame = scrollView.bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//    }
//    // Custom Navigation Bar
//    
//    func setupCustomNavigationBar() {
//        customNavBar.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(customNavBar)
//        NSLayoutConstraint.activate([
//            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            customNavBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            customNavBar.widthAnchor.constraint(equalToConstant: view.frame.width),
//            customNavBar.heightAnchor.constraint(equalToConstant: 56)
//        ])
//        
//        cancelButton.setTitle("Отменить", for: .normal)
//        cancelButton.setTitleColor(.blue, for: .normal)
//        cancelButton.translatesAutoresizingMaskIntoConstraints = false
//        customNavBar.addSubview(cancelButton)
//        
//        saveButton.setTitle("Сохранить", for: .normal)
//        saveButton.setTitleColor(.blue, for: .normal)
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        customNavBar.addSubview(saveButton)
//        
//        titleLabel.text = "Заголовок"
//        titleLabel.textColor = .black
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        customNavBar.addSubview(titleLabel)
//        
//        NSLayoutConstraint.activate([
//            // Констрейнты для кнопки "Отменить"
//            cancelButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 16),
//            cancelButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
//            
//            // Констрейнты для кнопки "Сохранить"
//            saveButton.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -16),
//            saveButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
//            
//            // Констрейнты для лейбла
//            titleLabel.centerXAnchor.constraint(equalTo: customNavBar.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor)
//        ])
//    }
//    
//    // Configure TextField
//    func setupTextField() {
//        textField.borderStyle = .roundedRect
//        textField.text = "Что надо сделать?"
//        textField.layer.cornerRadius = 16
//        textField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        textField.font = .systemFont(ofSize: 17)
//        textField.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
//        textField.textAlignment = .left
//        
//        contentView.addSubview(textField)
//        
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(textField)
//        NSLayoutConstraint.activate([
//            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
//            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            textField.widthAnchor.constraint(equalToConstant: 343),
//            textField.heightAnchor.constraint(equalToConstant: 120)
//        ])
//    }
//    
//    
//    // Configure importance Field
//    func setupSegmentedControl() {
//        
//        
//        // Создаем UISegmentedControl с тремя сегментами
//    let importanceSegmentedControl = UISegmentedControl(items: Array(repeating: "", count: 3))
//
//        // Задаем изображения для каждого сегмента
//        importanceSegmentedControl.setImage(UIImage(systemName: "arrow.down"), forSegmentAt: 0)
//        importanceSegmentedControl.setTitle("Нет", forSegmentAt: 1)
//        importanceSegmentedControl.setImage(UIImage(systemName: "exclamationmark.2"), forSegmentAt: 2)
//
//        importanceSegmentedControl.selectedSegmentIndex = 0
//
//        importanceSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
//
//        view.addSubview(importanceSegmentedControl)
//
// 
//        importanceSegmentedControl.selectedSegmentIndex = 0 // по умолчанию выбран первый сегмент
//
//        importanceSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
//
//        contentView.addSubview(importanceSegmentedControl)
//        
//        importanceSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            importanceSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 272),
//            importanceSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            importanceSegmentedControl.widthAnchor.constraint(equalToConstant: 49),
//            importanceSegmentedControl.heightAnchor.constraint(equalToConstant: 32)
//        ])
//        
//    }
//    
//    @objc func segmentChanged(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            print("Неважная")
//        case 1:
//            print("Обычная")
//        case 2:
//            print("Важная")
//        default:
//            break
//        }
//    }
//
//    
//        
//
//        
//        func loadToDoItem() {
//            // Загружаем данные ToDoItem в UI элементы здесь
//        }
//            }
//    
//    
//
