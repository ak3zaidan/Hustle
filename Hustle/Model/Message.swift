import Foundation

struct Message: Identifiable, Codable{
    var id: String
    var recieved: Bool
    var seen: Bool
    var text: String
    var timestamp: Date
}

