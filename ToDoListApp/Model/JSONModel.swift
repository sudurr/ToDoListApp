import Foundation

//MARK: - Расширение ToDoItem для JSONa

/*TodoItem, parsing json
 〉Расширение для структуры TodoItem
 〉Содержит функцию (static func parse(json: Any) -> TodoItem?) для разбора json
 〉Содержит вычислимое свойство (var json: Any) для формирования json'а
 〉Не сохранять в json важность, если она "обычная"
 〉Не сохранять в json сложные объекты (Date)
 〉Сохранять deadline только если он задан
 〉Обязательно использовать JSONSerialization (т.е. работу со словарем)
 */


extension ToDoItem {
    
    static func parse(json: Any) -> ToDoItem? {
        guard let dictionary = json as? [String: Any],
              let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let importance = dictionary["importance"] as? String,
              let isDone = dictionary["isDone"] as? Bool,
              let creationTimestamp = dictionary["creationDate"] as? Double else {
            return nil
        }
        
        var deadline: Date?
        
        if let checkedDeadline = dictionary["deadline"] as? Double {
            deadline = Date.init(timeIntervalSince1970: checkedDeadline)
        }
        
        let creationDate = Date(timeIntervalSince1970: creationTimestamp)
        
        return ToDoItem(id: id,
                        text: text,
                        importance: ToDoItem.Importance(rawValue: importance)!,
                        deadline: deadline,
                        isDone: isDone)
    }
    
    var json: Any {
        var dictionary: [String: Any] = [
            "id": id,
            "text": text,
            "importance": importance,
            "isDone": isDone,
            "creationDate": creationDate
        ]
        
        if importance != .regular {
            dictionary["importance"] = importance.rawValue
        }
        
        if let deadline = deadline {
            let deadlineTimestamp = deadline.timeIntervalSince1970
            dictionary["deadline"] = deadlineTimestamp
        }
        
        return dictionary
    }
}
