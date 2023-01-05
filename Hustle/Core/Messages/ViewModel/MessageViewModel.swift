import Foundation

class MessageViewModel: ObservableObject{
    @Published var usersAll = [User]()
    @Published var users = [User]()
    @Published var lastM = [Message]()
    @Published var message = [Message]()
    @Published var searchText = ""
    @Published var lastMessageId = ""
    let service = MessageService()
    let userService = UserService()
    
    var conversations: [User] {
        if searchText.isEmpty{
            return users
        } else {
            let lowercasedQuery = searchText.lowercased()
            return usersAll.filter({
                $0.username.contains(lowercasedQuery) ||
                $0.fullname.lowercased().contains(lowercasedQuery)
            })
        }
    }

    init(){
        self.fetchUsers()
        self.fetchConvos()
    }
        
    func fetchConvos(){
        var userList: [User] = []
        var dict = [User: Message]()
        service.getConversations() { users in
            userList = users
            userList.forEach { user in
                var messList: [Message] = []
                let id = user.id
                self.service.getMessages(otherUserUID: id ?? "") { message in
                    messList = message
                    if let text = messList.last{
                        dict[user] = text
                    }
                    let result = dict.sorted(by: { $0.value.timestamp > $1.value.timestamp } )
                    self.users.removeAll()
                    self.lastM.removeAll()
                    for element in result {
                        self.users.append(element.key)
                        self.lastM.append(element.value)
                    }
                }
            }
        }
    }
    
    func getMessages(withOtherUserUid otherUserUid: String){
        service.getMessages(otherUserUID: otherUserUid) { message in
            self.message = message

            message.forEach { doc in
                if let id = message.last?.id{
                    self.lastMessageId = id
                }
            }
        }
    }
    
    func sendMessages(withOtherUserUid otherUserUid: String, withText text: String){
        service.sendMessage(otherUserUID: otherUserUid, text: text) { _ in }
    }
    func fetchUsers(){
        userService.fetchUsers { users in
            self.usersAll = users
        }
    }
    func deleteConvo(withOtherUserUid otherUserUid: String){
        service.deleteConvo(otherUserUID: otherUserUid)
    }
    func seen(withOtherUserUid otherUserUid: String, withTextId textId: String){
        service.messageSeen(otherUserUID: otherUserUid, textId: textId) { return }
    }
    func seenTwo(withOtherUserUid otherUserUid: String){
        service.messageSeenTwo(otherUserUID: otherUserUid)
    }
}
