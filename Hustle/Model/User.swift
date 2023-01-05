import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable, Hashable {
    @DocumentID var id: String?
    let username: String
    let fullname: String
    var profileImageUrl: String
    let email: String
    var zipCode: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
}
