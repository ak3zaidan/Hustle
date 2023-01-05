import Foundation

struct Comment: Identifiable, Codable{
    var id: String
    var text: String
    var timestamp: Date
}
