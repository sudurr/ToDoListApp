import XCTest
@testable import ToDoListApp


final class ToDoListAppTests: XCTestCase {
    
    var item1 = ToDoItem(text: "Сходить выбросить мусор", importance: .important, changedDate: nil)
    
    var item2 = ToDoItem(text: "Купить помидоры", importance: .important)
    
    
    
    func testExample() throws {
        XCTAssertNotNil(item2.id)
        XCTAssertEqual(item1.importance, .important)
        
    }
}
