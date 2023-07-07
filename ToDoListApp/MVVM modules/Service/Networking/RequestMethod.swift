

import Foundation

enum RequestError: Error {
    case wrongURL(URLComponents)
    case unexpectedStatusCode(Int)
    case unexpectedResponse
    case badRequest
    case wrongAuth
    case notFound
    case serverError
}

extension RequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongURL(let urlComponents):
            return "Не удалось создать URL-адрес с помощью следующих компонентов: \(urlComponents)"
        case .unexpectedStatusCode(let code):
            return "Получен неожиданный код состояния: \(code)"
        case .unexpectedResponse:
            return "Получен неожиданный ответ от сервера"
        case .badRequest:
            return "Неправильный запрос или несинхронизированные данные"
        case .wrongAuth:
            return "Неверные данные авторизации"
        case .notFound:
            return "Запрашиваемый элемент не найден"
        case .serverError:
            return "Произошла ошибка на сервере"
        }
    }
}

enum RequestMethod: String {
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
}
