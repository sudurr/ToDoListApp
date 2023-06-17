import Foundation

//MARK: - Структура ToDoItem

/*TodoItem
 〉Иммутабельная структура
 〉Содержит уникальный идентификатор id, если не задан пользователем - генерируется (UUID().uuidString)
 〉Содержит обязательное строковое поле - text
 〉Содержит обязательное поле важность, должно быть enum, может иметь три варианта - "неважная", "обычная" и "важная"
 〉Содержит дедлайн, может быть не задан, если задан - дата
 〉Содержит флаг того, что задача сделана
 〉Содержит две даты - дата создания задачи (обязательна) и дата изменения (опциональна)
 */


struct ToDoItem {
    let id : String
    let text : String
    let importance : Importance
    let deadline : Date?
    let isDone : Bool
    let creationDate: Date
    let changedDate: Date?
    
    enum Importance: String {
        case notImportant = "Неважная"
        case regular = "Обычная"
        case important = "Важная"
    }
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, isDone: Bool = false, creationDate: Date = Date(), changedDate: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.changedDate = changedDate
    }
}
