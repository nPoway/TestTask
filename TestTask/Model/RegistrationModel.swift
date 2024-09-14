import Foundation

struct RegistrationResponse: Decodable {
    let success: Bool
    let user: RegisteredUser?
    let message: String?
}

struct RegisteredUser: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let photo: String
    let position: String
}
