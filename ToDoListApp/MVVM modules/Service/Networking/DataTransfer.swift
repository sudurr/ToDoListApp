

import Foundation

struct ListDTO: Codable {
    let status: String
    let list: [UnitDTO]
    let revision: Int?

    init(status: String = "ok", list: [UnitDTO], revision: Int? = nil) {
        self.status = status
        self.list = list
        self.revision = revision
    }
}

struct ItemDTO: Codable {
    let status: String
    let element: UnitDTO
    let revision: Int?

    init(status: String = "ok", element: UnitDTO, revision: Int? = nil) {
        self.status = status
        self.element = element
        self.revision = revision
    }
}

struct UnitDTO: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int?
    let done: Bool
    let color: String?
    let creationDate: Int
    let modificationDate: Int
    let lastUpdatedBy: String

    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case done
        case color
        case creationDate = "created_at"
        case modificationDate = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }
}
