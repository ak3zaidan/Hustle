import Firebase
import FirebaseFirestoreSwift

struct Tweet: Identifiable, Decodable{
    @DocumentID var id: String?
    
    var refId: String
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var likes: Int
    var comments: Int
    
    var user: User?
    var didLike: Bool? = false
    
}
