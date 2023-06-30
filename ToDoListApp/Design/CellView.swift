//
//  CellView.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 29.06.2023.
//

import Foundation
import UIKit

struct TodoItemCellViewModel {
    var isHighPriority: Bool {
        item.importance == .important
    }
    
    var title: String {
        item.text
    }
    
    
    var isHiddenSubtitle: Bool {
        item.deadline == nil
    }
    
    var subtitle: String? {
        guard let deadline = item.deadline else {
            return nil
        }
        
        let formatter = DateFormatterProvider.dateFormatter
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: deadline)
    }
    
    private let item: ToDoItem
    
    init(item: ToDoItem) {
        self.item = item
    }
}


final class DateFormatterProvider {
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru")
        return dateFormatter
    }
}
