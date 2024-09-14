import Foundation

struct PositionResponse: Decodable {
    let success: Bool
    let positions: [Position]
}

struct Position: Decodable {
    let id: Int
    let name: String
}
