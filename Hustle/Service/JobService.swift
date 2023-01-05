import Firebase
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct JobService{
    let db = Firestore.firestore()
    
    func uploadJob(caption: String, city: String, jobImageUrl: String, price: String, state: String, remote: Bool, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "caption": caption,
                    "price": price,
                    "city": city,
                    "jobimageurl": jobImageUrl,
                    "state": state,
                    "remote": remote,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        db.collection("jobs").document()
            .setData(data) { error in
                if let error = error {
                    print("failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func fetchJobs(withState state: String, completion: @escaping([Job]) -> Void){
        db.collection("jobs")
            .whereField("state", isEqualTo: state)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let jobs = documents.compactMap({ try? $0.data(as: Job.self)} )
                completion(jobs.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) )
            }
    }
    func fetchRemoteJobs(completion: @escaping([Job]) -> Void){
        var jobs: [Job] = []
        
        db.collection("jobs").whereField("remote", isEqualTo: true).getDocuments { querySnapshot, error in
            if error == nil{
                guard let documents = querySnapshot?.documents else{
                    print("error: \(String(describing: error))")
                    return
                }
                jobs = documents.compactMap{ document -> Job? in
                    do{
                        return try document.data(as: Job.self)
                    } catch{
                        print("error decoding document into job \(error)")
                        return nil
                    }
                }
                completion(jobs.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) )
            }
        }
    }
    
    func fetchUserJob(forUid uid: String, completion: @escaping([Job]) -> Void){
        db.collection("jobs")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let jobs = documents.compactMap({ try? $0.data(as: Job.self)} )
                completion(jobs.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) )
            }
    }
    
    func checkIfZipInDatabase(completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users")
            .document(uid)
            .getDocument{ snapshot, _ in
                guard let user = try? snapshot?.data(as: User.self) else { return }
                if (user.zipCode.rangeOfCharacter(from: .decimalDigits) != nil) {
                    completion(true)
                } else {
                    completion(false)
                }
            }
            
    }
    
    func uploadZipToDatabase(forZip zip: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users")
            .document(uid)
            .updateData(["zipCode": zip]){ _ in }
    }
    
    func getZipFromDataBase(completion: @escaping(String) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users")
            .document(uid)
            .getDocument{ snapshot, _ in
                guard let user = try? snapshot?.data(as: User.self) else { return }
                completion(user.zipCode)
            }
    }
}



