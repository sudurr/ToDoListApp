import Foundation

//MARK: - FileCache

class FileCache {
    private(set) var tasks: [UUID: ToDoItem] = [:]
    
    func add(task: ToDoItem) {
        tasks[task.id] = task
    }
    
    func remove(taskID: UUID) {
        tasks.removeValue(forKey: taskID)
    }
    
    func save(to fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let tasksArray = Array(tasks.values)
        let taskDictionaries = tasksArray.map { $0.json }
        let jsonData = try JSONSerialization.data(withJSONObject: taskDictionaries, options: [])
        try jsonData.write(to: url)
    }
    
    
    func load(from fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let jsonData = try Data(contentsOf: url)
        guard let taskDictionaries = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            throw NSError(domain: "com.example.MyApp", code: 1, userInfo: nil)
        }
        tasks = taskDictionaries.compactMap { ToDoItem.parse(json: $0) }.reduce(into: [UUID: ToDoItem]()) { $0[$1.id] = $1 }
    }
    
    func saveCSV(to fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let tasksArray = Array(tasks.values)
        let csvData = tasksArray.map { $0.csv }.joined(separator: "\n")
        try csvData.write(to: url, atomically: true, encoding: .utf8)
    }
    
    func loadCSV(from fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let csvData = try String(contentsOf: url, encoding: .utf8)
        let csvTasks = csvData.split(separator: "\n").compactMap { ToDoItem.parse(csv: String($0)) }
        tasks = Dictionary(uniqueKeysWithValues: csvTasks.map { ($0.id, $0) })
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
