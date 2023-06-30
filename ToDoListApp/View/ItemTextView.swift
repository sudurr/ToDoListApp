//
//  ItemTextView.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 25.06.2023.
//

import Foundation
import UIKit

final class ItemTextView: UITextView {

    func setItemTextView() -> UITextView {
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 20
        self.text = "Please write your task"

        self.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        self.font = UIFont.systemFont(ofSize: 17)
        self.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return self
    }
}
