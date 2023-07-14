
import Foundation
import CocoaLumberjackSwift
import SQLite

public final class FileCacheSQL {

    let todoItems = Table("ToDoItems")
    let id = Expression<String>("id")
    let text = Expression<String>("text")
    let importance = Expression<Importance.RawValue>("importance")
    let deadline = Expression<Int?>("deadline")
    let completed = Expression<Bool>("completed")
    let createDate = Expression<Int>("creationDate")
    let editDate = Expression<Int?>("modificationDate")
    let textColor = Expression<String>("textColor")
    private(set) var items: [String: TodoItem] = [:]
    private var database: Connection?

    init() {
        do {
            guard let itemFilesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Directory documents not found")
                return
            }
            let databaseURL = itemFilesDirectory.appendingPathComponent("fileCache.db")
            database = try Connection(databaseURL.path)

            createSQLTable()
            loadFromDatabaseSQL()

        } catch {
            DDLogError("SQL database initialization error: \(error)", level: .error)
        }
    }

    func createSQLTable() {
        do {
            guard let database = self.database else {
                DDLogError("SQL database connection error")
                return
            }

            let createTable = todoItems.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(importance)
                table.column(deadline)
                table.column(completed)
                table.column(createDate)
                table.column(editDate)
                table.column(textColor)
            }
            try database.run(createTable)
        } catch {
            DDLogError("SQL table creating error: \(error)", level: .error)
        }
    }

    func loadFromDatabaseSQL() {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error")
                return
            }
            let query = todoItems.order(createDate)
            let loadedItems = try database.prepare(query).map { row -> TodoItem in
                let item = TodoItem(
                    id: UUID(uuidString: row[id])!,
                    text: row[text],
                    importance: Importance(rawValue: row[importance]) ?? .regular,
                    deadline: row[deadline].flatMap { timestamp -> Date? in
                        return Date(timeIntervalSince1970: TimeInterval(timestamp)) },
                    isDone: row[completed],
                    creationDate: Date(timeIntervalSince1970: TimeInterval(row[createDate])),
                    modificationDate: row[editDate].flatMap { timestamp -> Date? in
                        return Date(timeIntervalSince1970: TimeInterval(timestamp)) },
                    textColor: "000000"
                )
                return item
            }

            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id.uuidString, $0) })
        } catch {
            DDLogError("SQL database items loading error: \(error)")
        }
    }

    func saveToDBSQL(items: [TodoItem]) {
        do {
            guard let dataBase = self.database else {
                DDLogError("SQL database connection error")
                return
            }

            for item in items {
                let deadline = item.deadline?.timeIntervalSince1970
                let creationDate = Int(item.creationDate.timeIntervalSince1970)
                let modificationDate = item.modificationDate?.timeIntervalSince1970

                let replaceStatement = """
                        REPLACE INTO toDoItems
                        (id, text, importance, deadline, isDone, creationDate, modificationDate)
                        VALUES
                        ('\(item.id)', ?, ?, ?, ?, ?, ?);
                        """

                try dataBase.run(replaceStatement,
                                 [item.text, item.importance.rawValue,
                                  deadline, item.isDone ? 1 : 0,
                                  creationDate, modificationDate])
            }

            let localItemIDs = items.map { $0.id.uuidString }
            let databaseItemIDs = try dataBase.prepare(todoItems.select(id)).map { UUID(uuidString: $0[id])!.uuidString }
            let deletedItemIDs = Set(databaseItemIDs).subtracting(localItemIDs)

            if !deletedItemIDs.isEmpty {
                let deleteQuery = todoItems.filter(deletedItemIDs.contains(id))
                try dataBase.run(deleteQuery.delete())
            }

            DDLogDebug("Saved to database SQL", level: .debug)

        } catch {
            DDLogError("SQL database saving error: \(error)", level: .error)
        }
    }
}
