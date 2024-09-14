import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let photo: String
}

struct UsersResponse: Decodable {
    let users: [User]
}
