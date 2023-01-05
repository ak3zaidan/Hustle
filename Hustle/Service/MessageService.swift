import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class MessageService: ObservableObject{
    let db = Firestore.firestore()
    
    func sendMessage(otherUserUID: String, text: String, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["id": "\(UUID())",
                    "recieved": false,
                    "seen": true,
                    "text": text,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        let data2 = ["id": "\(UUID())",                       "recieved": true,
                     "seen": false,
                     "text": text,
                     "timestamp": Timestamp(date: Date())] as [String : Any]
        let placeHolder = ["place": ""]
        
        db.collection("users").document(uid).collection("user-convo").document(otherUserUID)
            .setData(placeHolder) { error in
                if let error = error {
                    print("failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
            }
        db.collection("users").document(otherUserUID).collection("user-convo").document(uid)
            .setData(placeHolder) { error in
                if let error = error {
                    print("failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
            }

        db.collection("users").document(uid).collection("user-convo")
            .document(otherUserUID).collection("texts").document()
            .setData(data) { error in
                if let error = error {
                    print("failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
            }
        db.collection("users").document(otherUserUID).collection("user-convo")
            .document(uid).collection("texts").document()
            .setData(data2) { error in
                if let error = error {
                    print("failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func getMessages(otherUserUID: String, completion: @escaping([Message]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var messages: [Message] = []
        
        db.collection("users").document(uid).collection("user-convo").document(otherUserUID).collection("texts")
            .addSnapshotListener{ querySnapshot, error in
                if error == nil{
                    guard let documents = querySnapshot?.documents else{
                        print("error: \(String(describing: error))")
                        return
                    }
                    messages = documents.compactMap{ document -> Message? in
                        do{
                            return try document.data(as: Message.self)
                        } catch{
                            print("error decoding document into message \(error)")
                            return nil
                        }
                    }
                    messages.sort { $0.timestamp < $1.timestamp }
                    
                    completion(messages)
                }
            
        }
    }
    
    func getConversations(completion: @escaping([User]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var users = [User]()
        db.collection("users")
            .document(uid)
            .collection("user-convo")
            .getDocuments { snapshot, error in
                if error == nil{
                    guard let documents = snapshot?.documents else { return }
                    
                    documents.forEach { doc in
                        let userID = doc.documentID
                        
                        Firestore.firestore().collection("users")
                            .document(userID)
                        
                            .getDocument { snapshot, _ in
                                guard let user = try? snapshot?.data(as: User.self) else { return }
                                users.append(user)
                                completion(users)
                            }
                        
                    }
                }
            }
    
    }
    
    func deleteConvo(otherUserUID: String){
        if !(otherUserUID).isEmpty {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            db.collection("users").document(uid).collection("user-convo").document(otherUserUID).collection("texts")
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    
                    if !(documents).isEmpty{
                        documents.forEach { doc in
                            let docID = doc.documentID
                            Firestore.firestore().collection("users")
                                .document(uid).collection("user-convo")
                                .document(otherUserUID)
                                .collection("texts")
                                .document(docID)
                                .delete()
                        }
                        Firestore.firestore().collection("users")
                            .document(uid).collection("user-convo")
                            .document(otherUserUID)
                            .delete()
                    }
                }
            
        }
    }
    
    func messageSeen(otherUserUID: String, textId: String, completion: @escaping() -> Void){
        if (!(otherUserUID).isEmpty && !(textId).isEmpty){
            guard let uid = Auth.auth().currentUser?.uid else { return }
            db.collection("users").document(uid)
                .collection("user-convo").document(otherUserUID)
                .collection("texts").document(textId)
                .getDocument { snapshot, _ in
                    guard let message = try? snapshot?.data(as: Message.self) else { return }
                    if message.recieved == true{
                        Firestore.firestore().collection("users").document(uid).collection("user-convo")
                            .document(otherUserUID)
                            .collection("texts")
                            .document(textId)
                            .updateData(["seen": message.seen == true]) { _ in
                                completion()
                            }

                    }
                }
            
        }
    }
    func messageSeenTwo(otherUserUID: String){
        if (!(otherUserUID).isEmpty){
            var mess: [Message] = []
            guard let uid = Auth.auth().currentUser?.uid else { return }
            db.collection("users").document(uid)
                .collection("user-convo").document(otherUserUID)
                .collection("texts")
                .getDocuments { snapshot, _ in
                    guard let documents = snapshot?.documents else { return }
                    mess = documents.compactMap{ document -> Message? in
                        do{
                            return try document.data(as: Message.self)
                        } catch{
                            return nil
                        }
                    }
                    mess.sort { $0.timestamp > $1.timestamp }
                    guard let message = mess.first else { return }
                    if message.recieved == true{
                        Firestore.firestore().collection("users").document(uid).collection("user-convo")
                            .document(otherUserUID)
                            .collection("texts")
                            .whereField("id", isEqualTo: message.id)
                            .getDocuments { snapshot, _ in
                                guard let documents = snapshot?.documents else { return }
                                
                                documents.forEach{ doc in
                                    let id = doc.documentID
                                    Firestore.firestore().collection("users").document(uid).collection("user-convo")
                                        .document(otherUserUID)
                                        .collection("texts")
                                        .document(id)
                                        .updateData(["seen": true])
                                            }}}}}
        }
}




