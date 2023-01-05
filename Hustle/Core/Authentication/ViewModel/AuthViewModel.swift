import SwiftUI
import Firebase

class AuthViewModel: ObservableObject{
    private let service = UserService()
    private var tempUserSession: FirebaseAuth.User?
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthUser = false
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if let error = error{
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else{ return }
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String, zipCode: String){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error{
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.tempUserSession = user
            
            let data = ["email": email,
                        "username": username.lowercased(),
                        "fullname": fullname,
                        "uid": user.uid,
                        "zipCode": zipCode]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data){ _ in
                    self.didAuthUser = true
                }
            
        }
    }
    
    func signOut(){
        
        self.didAuthUser = false
        //signs user out on UI
        userSession = nil
        //signs user out on backend
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage){
        guard let uid = tempUserSession?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]){ _ in
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                }
        }
    }
    
    func fetchUser(){
        guard let uid = self.userSession?.uid else { return }
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}
