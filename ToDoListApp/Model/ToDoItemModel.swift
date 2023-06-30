import Foundation

struct ToDoItem {
    let id : String
    let text : String
    let importance : Importance
    let deadline : Date?
    let isDone : Bool
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


//MARK: - JSON Parsing


extension ToDoItem {
    static func parse(json: Any) -> ToDoItem? {
        guard let js = json as? [String: Any] else {
            return nil
        }

        guard
            let id = js[kId] as? String,
            let text = js[kText] as? String,
            let createdAt = (js[kCreationDate] as? Int).flatMap ({ Date(timeIntervalSince1970: TimeInterval($0)) })
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

private let kId = "id"
private let kText = "text"
private let kImportance = "importance"
private let kDeadline = "deadline"
private let kIsDone = "done"
private let kCreationDate = "creationDate"
private let kChangedDate = "changedDate"

//extension ToDoItem {
//
//    static func parse(json: Any) -> ToDoItem? {
//        guard let dictionary = json as? [String: Any],
//              let id = dictionary["id"] as? String,
//              let text = dictionary["text"] as? String,
//              let isDone = dictionary["isDone"] as? Bool,
//              let creationTimestamp = dictionary["creationDate"] as? TimeInterval else {
//            return nil
//        }
//
//        let importanceString = dictionary["importance"] as? String ?? "Обычная"
//        guard let importance = Importance(rawValue: importanceString) else {
//            return nil
//        }
//
//        let creationDate = Date(timeIntervalSince1970: creationTimestamp)
//
//        var deadline: Date?
//        if let deadlineTimestamp = dictionary["deadline"] as? Double {
//            deadline = Date(timeIntervalSince1970: deadlineTimestamp)
//        } else {
//            return nil
//        }
//
//        var changedDate: Date?
//        if let changedTimestamp = dictionary["changedDate"] as? Double {
//            changedDate = Date(timeIntervalSince1970: changedTimestamp)
//        } else {
//            return nil
//        }
//
//        return ToDoItem(id: id,
//                        text: text,
//                        importance: importance,
//                        deadline: deadline,
//                        isDone: isDone)
//    }
//
//    var json: Any {
//        var dictionary: [String: Any] = [
//            "id": id,
//            "text": text,
//            "isDone": isDone,
//            "creationDate": creationDate
//        ]
//
//        if importance != .regular {
//            dictionary["importance"] = importance.rawValue
//        }
//
//        if let deadline = deadline {
//            let deadlineTimestamp = deadline.timeIntervalSince1970
//            dictionary["deadline"] = deadlineTimestamp
//        }
//
//        if let changedDate = changedDate {
//            let changedTimestamp = changedDate.timeIntervalSince1970
//            dictionary["changedDate"] = changedTimestamp
//        }
//
//        return dictionary
//    }
//}


//MARK: - CSV Parsing

//extension ToDoItem {
//    static func parse(csv: String) -> ToDoItem? {
//        let components = csv.components(separatedBy: ";")
//
//        guard components.count == 7 else {return nil}
//
//        guard
//            let id = UUID(uuidString: components[0]) ?? nil,
//            let importance = (components[2].isEmpty ? nil : components[2]).map(Importance.init(rawValue:)) ?? .regular,
//            let creationDateTimeInterval = TimeInterval(components[5])
//        else { return nil}
//
//
//
//        let text = components[1]
//        let isDone = Bool(components[4]) ?? false
//        let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
//
//        var deadline: Date?
//        if let deadlineTimestamp = Double(components[3]) {
//            deadline = Date(timeIntervalSince1970: deadlineTimestamp)
//        }
//
//        var changedDate: Date?
//        if let changedDateTimestamp = Double(components[6]) {
//            changedDate = Date(timeIntervalSince1970: changedDateTimestamp)
//        }
//
//        return ToDoItem(id: id,
//                        text: text,
//                        importance: importance,
//                        deadline: deadline,
//                        isDone: isDone,
//                        creationDate: creationDate,
//                        changedDate: changedDate)
//    }
//
//    var csv: String {
//        var components: [String] = [id.uuidString,
//                                    text, String(isDone),
//                                    String(creationDate.timeIntervalSince1970)]
//
//        if importance != .regular {
//            components.append(importance.rawValue)
//        } else {
//            components.append("")
//        }
//
//        if let deadline = deadline {
//            let deadlineTimestamp = deadline.timeIntervalSince1970
//            components.append(String(deadlineTimestamp))
//        } else {
//            components.append("")
//        }
//
//        return components.joined(separator: ";")
//    }
//}
