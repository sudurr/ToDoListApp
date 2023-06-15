//
//  FileCacheModel.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 15.06.2023.
//

import Foundation

//MARK: - FileCache

/*
 〉Содержит закрытую для внешнего изменения, но открытую для получения коллекцию TodoItem
 〉Содержит функцию добавления новой задачи
 〉Содержит функцию удаления задачи (на основе id)
 〉Содержит функцию сохранения всех дел в json файл
 Можно сохранять в documentDirectory, можно в Library/Application Support.
 〉Содержит функцию загрузки всех дел из json файла
 〉Можем иметь несколько разных json файлов
 〉Предусмотреть механизм защиты от дублирования задач (сравниванием id)
 Если в при добавлении новой задачи приходит TodoItem с id который уже есть в коллекции, то мы перезаписываем данные для TodoItem c таким id.
 */

class FileCache {
    private(set) var tasks: [ToDoItem] = []
    
    func add(task: ToDoItem) {
        if !tasks.contains(where: { $0.id == task.id }) {
            tasks.append(task)
        }
    }
    
    func remove(taskID: String) {
        tasks.removeAll(where: { $0.id == taskID })
    }
    
    func save(to fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let taskDictionaries = tasks.map { ["id": $0.id,
                                            "text": $0.text,
                                            "importance": $0.importance,
                                            "isDone": $0.isDone,
                                            "creationDate": $0.creationDate] }
        let data = try JSONSerialization.data(withJSONObject: taskDictionaries, options: [])
        try data.write(to: url)
    }
    
    func load(from fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let data = try Data(contentsOf: url)
        let taskDictionaries = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        tasks = taskDictionaries?.compactMap { dict in
            guard let id = dict["id"] as? String,
                  let text = dict["text"] as? String,
                  let isDone = dict["isDone"] as? Bool else {
                return
            }
            return ToDoItem(id: id, text: text, isDone: isDone)
        } ?? []
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
