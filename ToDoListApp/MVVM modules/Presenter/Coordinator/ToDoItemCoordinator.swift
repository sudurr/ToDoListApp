//
//  ToDoItemCoordinator.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 08.07.2023.
//

import Foundation

@MainActor
protocol TodoItemCoordinator: AnyObject {
    func closeDetails()
}
