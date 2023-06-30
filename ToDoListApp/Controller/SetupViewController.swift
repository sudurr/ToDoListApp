//
//  SetupViewController.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 25.06.2023.
//

import Foundation
import UIKit

final class SetupViewController: UIViewController {

    let itemTextView = ItemTextView()
    let stackView = StackView()
    let deleteButton = DeleteButton()
    
    override var navigationController: UINavigationController? {
        UINavigationController()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setNavigationBar()
        view.addSubview(itemTextView.setItemTextView())
        setTaskTextViewConstraints()
        view.addSubview(stackView.setStackView())
        setStackConstraints()
        view.addSubview(deleteButton.setDeleteButton())
        setDeleteButtonConstraints()

    }
    
    private func setDeleteButtonConstraints() {
        deleteButton.button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.button.topAnchor.constraint(equalTo: stackView.stack.bottomAnchor, constant: 16),
            deleteButton.button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteButton.button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteButton.button.heightAnchor.constraint(equalToConstant: 56),

        ])
        deleteButton.button.layer.cornerRadius = 16
    }

    private func setStackConstraints() {
        stackView.stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.stack.topAnchor.constraint(equalTo: itemTextView.bottomAnchor, constant: 16),
            stackView.stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        stackView.stack.layer.cornerRadius = 16
    }

    private func setNavigationBar() {
        view.backgroundColor = UIColor(red: 247 / 255, green: 246 / 255, blue: 242 / 255, alpha: 1)
        title = "Дело"
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = cancelButton
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    // delete button

    private func setTaskTextViewConstraints() {
        itemTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemTextView.heightAnchor.constraint(equalToConstant: 120),
            itemTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            itemTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            itemTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56)
            ])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.itemTextView.resignFirstResponder()
    }

    @objc func cancelButtonButtonTapped() {
        
    }

    @objc func saveButtonButtonTapped() {
        
        let itemText = itemTextView.text

          let fileCache = FileCache()
          
          do {
              try fileCache.save(to: "ToDoItem")
              print(itemText)
          } catch {
              print("Ошибка при сохранении: \(error)")
          }
    
}

    override func viewWillAppear(_ animated: Bool) {

    }

}



