import Foundation

struct Song: Identifiable, Codable {
    let id: String
    let title: String
    let url: String
    var isLocal: Bool = false
}
