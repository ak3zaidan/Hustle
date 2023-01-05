

import SwiftUI
import Kingfisher

struct MessagesView: View {
    @StateObject var messagesManager = MessageService()
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var viewModeler: MessageViewModel
    @State var value: Message = Message(id: "", recieved: false, seen: false, text: "", timestamp: Date())

    init(user: User){
        self.viewModel = ProfileViewModel(user: user)
        self.viewModeler = MessageViewModel()
        viewModeler.getMessages(withOtherUserUid: viewModel.user.id ?? "")
    }
    var body: some View {
        VStack{
            VStack{
                HStack(spacing: 20){
                    KFImage(URL(string: viewModel.user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)

                    VStack(alignment: .leading){
                        Text(viewModel.user.fullname)
                            .font(.headline).bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
                
                ScrollViewReader{ proxy in
                    ScrollView{
                        ForEach(viewModeler.message){ message in
                            MessageBubble(message: message)
                        }
                        
                    }
                    .onAppear(){
                        withAnimation {
                            proxy.scrollTo(viewModeler.lastMessageId, anchor: .bottom)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of: viewModeler.lastMessageId){ id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                        viewModeler.seen(withOtherUserUid: viewModel.user.id ?? "", withTextId: id)
                    }
                }
            }
            .background(Color("pink"))
            
            MessagesField(user: viewModel.user)
                .environmentObject(messagesManager)
        }
        .onAppear {
            viewModeler.seenTwo(withOtherUserUid: viewModel.user.id ?? "")
        }
    }
}







