import XCTest

@testable import ToDoListApp

class ToDoItemModelTests: XCTestCase {
    
    func testToDoItemInitialization() {
        // Arrange
        let id = UUID().uuidString
        let text = "купить помидоры"
        let importance = ToDoItem.Importance.important
        let deadline = Date(timeIntervalSinceNow: 60*60*24)
        let isDone = false
        let creationDate = Date()
        
        // Act
        let toDoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isDone: isDone, creationDate: creationDate)
        
        // Assert
        XCTAssertEqual(toDoItem.id, id)
        XCTAssertEqual(toDoItem.text, text)
        XCTAssertEqual(toDoItem.importance, importance)
        XCTAssertEqual(toDoItem.deadline, deadline)
        XCTAssertEqual(toDoItem.isDone, isDone)
        XCTAssertEqual(toDoItem.creationDate, creationDate)
        XCTAssertNil(toDoItem.changedDate)
    }
    
    func testToDoItemDefaultInitialization() {
        // Act
        let toDoItem = ToDoItem(text: "Test ToDo", importance: .notImportant)
        
        // Assert
        XCTAssertNotNil(toDoItem.id)
        XCTAssertEqual(toDoItem.text, "Test ToDo")
        XCTAssertEqual(toDoItem.importance, .notImportant)
        XCTAssertNil(toDoItem.deadline)
        XCTAssertFalse(toDoItem.isDone)
        XCTAssertNotNil(toDoItem.creationDate)
        XCTAssertNil(toDoItem.changedDate)
    }
    
    func testParseFromJSON() {
        // Arrange
        let json: [String: Any] = [
            "id": "testID",
            "text": "Test text",
            "importance": ToDoItem.Importance.important.rawValue,
            "isDone": true,
            "creationDate": Date().timeIntervalSince1970,
            "deadline": Date(timeIntervalSinceNow: 60*60*24).timeIntervalSince1970
        ]
        
        // Act
        let toDoItem = ToDoItem.parse(json: json)
        
        // Assert
        XCTAssertNotNil(toDoItem)
        XCTAssertEqual(toDoItem?.id, "testID")
        XCTAssertEqual(toDoItem?.text, "Test text")
        XCTAssertEqual(toDoItem?.importance, .important)
        XCTAssertEqual(toDoItem?.isDone, true)
        XCTAssertNotNil(toDoItem?.creationDate)
        XCTAssertNotNil(toDoItem?.deadline)
    }
    
    func testConvertToJSON() {
        // Arrange
        let toDoItem = ToDoItem(id: "testID",
                                text: "Test text",
                                importance: .important,
                                deadline: Date(timeIntervalSinceNow: 60*60*24),
                                isDone: true)
        
        // Act
        let json = toDoItem.json
        guard let dictionary = json as? [String: Any] else {
            XCTFail("Failed to convert ToDoItem to JSON")
            return
        }
        
        // Assert
        XCTAssertEqual(dictionary["id"] as? String, "testID")
        XCTAssertEqual(dictionary["text"] as? String, "Test text")
        XCTAssertEqual(dictionary["importance"] as? String, ToDoItem.Importance.important.rawValue)
        XCTAssertEqual(dictionary["isDone"] as? Bool, true)
        XCTAssertNotNil(dictionary["creationDate"])
        XCTAssertNotNil(dictionary["deadline"])
    }
}
