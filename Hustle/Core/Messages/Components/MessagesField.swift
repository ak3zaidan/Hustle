import SwiftUI


struct MessagesField: View {

    @State private var message = ""
    @ObservedObject var viewModel: MessageViewModel
    @ObservedObject var viewModeler: ProfileViewModel
    
    init(user: User){
        self.viewModeler = ProfileViewModel(user: user)
        self.viewModel = MessageViewModel()
    }
    
    var body: some View {
        HStack{
            CustomMessageField(placeholder: Text("Enter Your Message Here"), text: $message)
            Button {
                viewModel.sendMessages(withOtherUserUid: viewModeler.user.id ?? "", withText: message)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("pink"))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("gray"))
        .cornerRadius(50)
        .padding()
    }
}


struct CustomMessageField: View{
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View{
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder
                    .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)

        }
    }
}
