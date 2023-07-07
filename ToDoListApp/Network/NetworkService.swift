////
////  NetworkService.swift
////  ToDoListApp
////
////  Created by Судур Сугунушев on 06.07.2023.
////
//
//
////protocol NetworkService {
////    var numberOfTasks: Int { get }
////    @MainActor func incrementNumberOfTasks()
////    @MainActor func decrementNumberOfTasks()
////    func loadTodoList() async throws -> [ToDoItem]
////    func syncTodoList(_ todoList: [ToDoItem]) async throws -> [ToDoItem]
////    func getTodoItem(id: String) async throws -> ToDoItem?
////    @discardableResult func addTodoItem(_ todoItem: ToDoItem) async throws -> ToDoItem?
////    @discardableResult func changeTodoItem(_ todoItem: ToDoItem) async throws -> ToDoItem?
////    @discardableResult func deleteTodoItem(id: String) async throws -> ToDoItem?
////}
//
//
//import Foundation
//import CocoaLumberjackSwift
//
//public protocol NetworkingService {
//    func getList(completion: @escaping (Result<([ToDoItem], Int), Error>) -> Void)
//    func updateList(revision: Int, items: [ToDoItem], completion: @escaping (Result<Void, Error>) -> Void)
//    func getItem(id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void)
//    func addItem(revision: Int, item: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void)
//    func updateItem(id: String, item: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void)
//    func deleteItem(id: String, revision: Int, completion: @escaping (Result<ToDoItem, Error>) -> Void)
//}
//
//public class DefaultNetworkingService: NetworkingService {
//    private let baseURL = URL(string: "https://beta.mrdekk.ru/todobackend")
//    private let session: URLSession
//    private let token = "palaeontologically"
//
//    public init() {
//
//        let sessionConfiguration = URLSessionConfiguration.default
//        sessionConfiguration.timeoutIntervalForResource = 30
//        self.session = URLSession(configuration: sessionConfiguration)
//    }
//
//    public func getList(completion: @escaping (Result<([ToDoItem], Int), Error>) -> Void) {
//        guard var url = baseURL else { return }
//        url = url.appendingPathComponent("list")
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//
//        let requestConst = request
//
//        DispatchQueue.global().async {
//            self.sendRequest(request: requestConst) { result in
//                switch result {
//                case .success(let data):
//                    do {
//                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        guard let revision = response?["revision"] as? Int else { return }
//                        let listData = response?["list"] as? [[String: Any]]
//                        let items = listData?.compactMap { ToDoItem.sharingParse(sharingJSON: $0) } ?? []
//                        completion(.success((items, revision)))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//
//    }
//
//    public func updateList(revision: Int, items: [ToDoItem], completion: @escaping (Result<Void, Error>) -> Void) {
//        guard var url = baseURL else { return }
//        url = url.appendingPathComponent("list")
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.addValue(String(revision), forHTTPHeaderField: "X-Last-Known-Revision")
//
//        let requestData = items.compactMap { $0.json }
//        do {
//            let json = try JSONSerialization.data(withJSONObject: requestData, options: [])
//            request.httpBody = json
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        let requestConst = request
//
//        DispatchQueue.global().async {
//            self.sendRequest(request: requestConst) { result in
//                switch result {
//                case .success:
//                    completion(.success(()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    public func getItem(id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
//        guard var url = baseURL else { return }
//        url = url.appendingPathComponent("list/\(id)")
//        let request = URLRequest(url: url)
//
//        DispatchQueue.global().async {
//            self.sendRequest(request: request) { result in
//                switch result {
//                case.success(let data):
//                    do {
//                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        if let itemData = response?["element"] as? [String: Any],
//                           let item = ToDoItem.parse(json: itemData) {
//                            completion(.success(item))
//                        } else {
//                            completion(.failure(NetworkingError.invalidData))
//                            return
//                        }
//                    } catch {
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    public func addItem(revision: Int, item: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard var url = baseURL else { return }
//        url = url.appendingPathComponent("list")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue(String(revision), forHTTPHeaderField: "X-Last-Known-Revision")
//        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//
//        do {
//            let outputDictionary = item.sharingJSON
//
//            let requestData = try JSONSerialization.data(withJSONObject: outputDictionary, options: [])
//            request.httpBody = requestData
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        let requestConst = request
//
//        DispatchQueue.global().async {
//            self.sendRequest(request: requestConst) { result in
//                switch result {
//                case .success:
//                    completion(.success(()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    public func updateItem(id: String, item: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard var url = baseURL else { return }
//        url = url.appendingPathComponent("list/\(id)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//
//        do {
//            let requestData = try JSONSerialization.data(withJSONObject: item.json, options: [])
//            request.httpBody = requestData
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        let requestConst = request
//
//        DispatchQueue.global().async {
//            self.sendRequest(request: requestConst) { result in
//                switch result {
//                case .success:
//                    completion(.success(()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    public func deleteItem(id: String, revision: Int, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
//        guard var url = baseURL else { return }
//        url = url.appendingPathComponent("list/\(id)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        request.addValue(String(revision), forHTTPHeaderField: "X-Last-Known-Revision")
//
//        let requestConst = request
//
//        DispatchQueue.global().async {
//            self.sendRequest(request: requestConst) { result in
//                switch result {
//                case .success(let data):
//                    do {
//                        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        if let itemData = response?["element"] as? [String: Any],
//                           let item = ToDoItem.sharingParse(sharingJSON: itemData) {
//                            completion(.success(item))
//                        } else {
//                            completion(.failure(NetworkingError.invalidData))
//                            return
//                        }
//                    } catch {
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    private func sendRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
//        let task = session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(NetworkingError.invalidResponse))
//                return
//            }
//
//            guard (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(NetworkingError.httpError(statusCode: httpResponse.statusCode)))
//                return
//            }
//
//            guard let responseData = data else {
//                completion(.failure(NetworkingError.emptyResponse))
//                return
//            }
//
//            completion(.success(responseData))
//        }
//
//        task.resume()
//    }
//}
//
//enum NetworkingError: Error {
//    case invalidResponse
//    case httpError(statusCode: Int)
//    case emptyResponse
//    case invalidData
//}
