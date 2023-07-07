
import Foundation

@MainActor
protocol TodoItemViewOutput {
    var todoItemLoaded: ((TodoItem) -> Void)? { get set }
    var changesSaved: (() -> Void)? { get set }
    func loadItemIfExist()
    func saveItem(text: String, importance: Importance, deadline: Date?, textColor: String)
    func deleteItem()
    func close()
}
