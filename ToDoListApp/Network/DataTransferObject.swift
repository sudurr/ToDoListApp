////
////  DataTransferObject.swift
////  ToDoListApp
////
////  Created by Судур Сугунушев on 07.07.2023.
////
//
//import Foundation
//
//struct TodoListDTO: Codable {
//    let status: String
//    let list: [ElementDTO]
//    let revision: Int?
//
//    init(status: String = "ok", list: [ElementDTO], revision: Int? = nil) {
//        self.status = status
//        self.list = list
//        self.revision = revision
//    }
//}
//
//struct TodoItemDTO: Codable {
//    let status: String
//    let element: ElementDTO
//    let revision: Int?
//
//    init(status: String = "ok", element: ElementDTO, revision: Int? = nil) {
//        self.status = status
//        self.element = element
//        self.revision = revision
//    }
//}
//
//struct ElementDTO: Codable {
//    let id: String
//    let text: String
//    let importance: String
//    let deadline: Int?
//    let done: Bool
//    let color: String?
//    let creationDate: Int
//    let changedDate: Int
//    let lastUpdatedBy: String
//
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case text
//        case importance
//        case deadline
//        case done
//        case color
//        case creationDate = "created_at"
//        case changedDate = "changed_at"
//        case lastUpdatedBy = "last_updated_by"
//    }
//}
