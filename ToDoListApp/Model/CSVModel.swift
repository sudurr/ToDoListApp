import Foundation

//MARK: - Задание со звездочкой *

/*
〉Реализовать расширение TodoItem для разбора формата СSV
〉Содержит функцию (static func parse(csv: String) -> TodoItem?) для разбора CSV
〉Содержит вычислимое свойство (var csv: String) для формирования CSV
〉Не сохранять в csv важность, если она "обычная"
〉Не сохранять в csv сложные объекты (Date), переводить в более простой формат
〉Сохранять deadline только если он задан
〉FileCache cодержит функцию сохранения всех дел в csv файл
〉FileCache содержит функцию загрузки всех дел из csv файла
〉Можем иметь несколько разных csv файлов
CSV-файлы (файлы данных с разделителями) — это файлы особого типа, которые можно создавать и редактировать в Excel. В CSV-файлах данные хранятся не в столбцах, а разделенные "," или ";". Текст и числа, сохраненные в CSV-файле, можно легко переносить из одной программы в другую.
*/

extension ToDoItem {
    static func parse(csv: String) -> ToDoItem? {
        let components = csv.components(separatedBy: ";")
        guard components.count >= 5 else { //проверка корректности формата с помощью подсчета компонентов
            return nil
        }

        let id = components[0]
        let text = components[1]
        let importance = Importance(rawValue: components[2]) ?? .regular
        let isDone = Bool(components[3]) ?? false
        let creationDate = Date(timeIntervalSince1970: Double(components[4]) ?? 0)
        var deadline: Date?
        if let deadlineTimestamp = Double(components[5]) {
            deadline = Date(timeIntervalSince1970: deadlineTimestamp)
        }

        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: isDone,
                        creationDate: creationDate)
    }

    var csv: String {
        var components: [String] = [id, text, String(isDone), String(creationDate.timeIntervalSince1970)]

        if importance != .regular {
            components.append(importance.rawValue)
        } else {
            components.append(" ")
        }

        if let deadline = deadline {
            let deadlineTimestamp = deadline.timeIntervalSince1970
            components.append(String(deadlineTimestamp))
        } else {
            components.append(" ")
        }

        return components.joined(separator: ";")
    }
}
