import Foundation

struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let changedDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isDone: Bool = false,
        creationDate: Date = Date(),
        changedDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.changedDate = changedDate
    }
}

// MARK: - JSON Parsing

private let kId = "id"
private let kText = "text"
private let kImportance = "importance"
private let kDeadline = "deadline"
private let kIsDone = "done"
private let kCreationDate = "creationDate"
private let kChangedDate = "changedDate"

extension ToDoItem {
    static func parse(json: Any) -> ToDoItem? {
        guard let js = json as? [String: Any] else {
            return nil
        }

        guard
            let id = js[kId] as? String,
            let text = js[kText] as? String,
            let _ = (js[kCreationDate] as? Int).flatMap ({ Date(timeIntervalSince1970: TimeInterval($0)) })
        else {
            return nil
        }

        let importance = (js[kImportance] as? String).flatMap(Importance.init(rawValue:)) ?? .regular
        let deadline = (js[kDeadline] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
        let isDone = (js[kIsDone] as? Bool) ?? false
        let changedAt = (js[kChangedDate] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }

        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: isDone
                        )
    }

    var json: Any {
        var res: [String: Any] = [:]
        res[kId] = id
        res[kText] = text
        if importance != .regular {
            res[kImportance] = importance.rawValue
        }
        if let deadline = deadline {
            res[kDeadline] = Int(deadline.timeIntervalSince1970)
        }
        res[kIsDone] = isDone
        res[kCreationDate] = Int(creationDate.timeIntervalSince1970)
        if let changedDate = changedDate {
            res[kChangedDate] = Int(changedDate.timeIntervalSince1970)
        }
        return res
    }
}
