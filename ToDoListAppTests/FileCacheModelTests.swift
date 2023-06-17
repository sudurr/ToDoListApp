//
//  FileCacheModelTests.swift
//  ToDoListAppTests
//
//  Created by Судур Сугунушев on 16.06.2023.
//

//import XCTest

//final class FileCacheModelTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}


import XCTest
@testable import ToDoListApp

class FileCacheTests: XCTestCase {
    var fileCache: FileCache!
    var testFileName: String!

    override func setUp() {
        super.setUp()
        fileCache = FileCache()
        testFileName = "testFile.json"
        
        // Delete test file before each test
        do {
            let url = fileCache.getDocumentsDirectory().appendingPathComponent(testFileName)
            try FileManager.default.removeItem(at: url)
        } catch {
            // If removing item fails, it means it doesn't exist which is fine for our setup
            print("File removal error: \(error)")
        }
    }

    func testAddTask() {
        // Arrange
        let task = ToDoItem(text: "Test", importance: .regular)
        
        // Act
        fileCache.add(task: task)
        
        // Assert
        XCTAssertTrue(fileCache.tasks.contains { $0.id == task.id })
    }

    func testRemoveTask() {
        // Arrange
        let task = ToDoItem(text: "Test", importance: .regular)
        fileCache.add(task: task)
        
        // Act
        fileCache.remove(taskID: task.id)
        
        // Assert
        XCTAssertFalse(fileCache.tasks.contains { $0.id == task.id })
    }

    func testSaveAndLoad() {
        // Arrange
        let task = ToDoItem(text: "Test", importance: .regular)
        fileCache.add(task: task)
        
        // Act
        do {
            try fileCache.save(to: testFileName)
            try fileCache.load(from: testFileName)
        } catch {
            XCTFail("Saving or loading file threw an error: \(error)")
        }
        
        // Assert
        XCTAssertTrue(fileCache.tasks.contains { $0.id == task.id })
    }
}
