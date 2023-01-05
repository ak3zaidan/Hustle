import Firebase
import FirebaseFirestoreSwift

struct Job: Identifiable, Decodable{
    @DocumentID var id: String?
    
    let caption: String
    let price: String
    let timestamp: Timestamp
    let uid: String
    var jobimageurl: String?
    let city: String
    let state: String
    let remote: Bool

    var user: User?
    
}
