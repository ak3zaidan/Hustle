import Foundation

class FeedViewModel: ObservableObject{
    
    @Published var tweets = [Tweet]()
    let service = TweetService()
    let userService = UserService()
    
    init(){
        fetchNew()
    }
    
    func fetchHot(){
        service.fetchHot { tweets in
            self.tweets = tweets
            
            for i in 0 ..< tweets.count {
                
                let uid = tweets[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.tweets[i].user = user
                    
                }
            }
        }
    }
    func fetchLeaderBoard(){
        service.fetchLeaderBoard { tweets in
            self.tweets = tweets
            
            for i in 0 ..< tweets.count {
                
                let uid = tweets[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.tweets[i].user = user
                    
                }
            }
        }
    }
    func fetchNew(){
        service.fetchNew { tweets in
            self.tweets = tweets
            
            for i in 0 ..< tweets.count {
                
                let uid = tweets[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.tweets[i].user = user
                    
                }
            }
        }
    }
}
