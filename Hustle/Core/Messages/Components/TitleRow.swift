import SwiftUI
import Kingfisher

struct TitleRow: View {
    let user: User
    @State var lastMessage: String = ""
    @State var dateFinal: String = ""
    @State var value: Message = Message(id: "", recieved: false, seen: false, text: "", timestamp: Date())
    @StateObject var viewModel = MessageViewModel()
    var body: some View {
        HStack(spacing: 20){
            KFImage(URL(string: user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                
            VStack(alignment: .leading){
                Text(user.fullname)
                    .onReceive(viewModel.$users) { users in
                    }
                    .font(value.seen ? .headline : .headline.bold())
                    .foregroundColor(value.seen ? .black : .blue)
                Text(lastMessage)
                    .onReceive(viewModel.$users, perform: { users in
                        if let index = viewModel.users.firstIndex(of: user){
                            value = viewModel.lastM[index]
                            
                            let components = value.text.components(separatedBy: .whitespacesAndNewlines)
                            let words = components.filter { !$0.isEmpty }
                            if words.count > 9{
                                let x = words.count - 9
                                let str = value.text
                                let reversed = String(str.reversed())
                                let string = reversed.split(separator: " ", maxSplits: x)
                                let new = (string[x])
                                lastMessage = String(new.reversed()) + "..."
                            } else {
                                lastMessage = value.text
                            }
                        }
                    })
                    .onAppear {
                        viewModel.fetchConvos()
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(dateFinal)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(10)
                .onReceive(viewModel.$users) { users in
                    let dateString = value.timestamp.formatted(.dateTime.month().day().year().hour().minute())
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
                    if let date = dateFormatter.date(from:dateString){
                        if Calendar.current.isDateInToday(date){dateFinal = value.timestamp.formatted(.dateTime.hour().minute())}
                        else if Calendar.current.isDateInYesterday(date) {dateFinal = "Yesterday"}
                        else{
                            if let dayBetween  = Calendar.current.dateComponents([.day], from: value.timestamp, to: Date()).day{
                                dateFinal = String(dayBetween + 1) + "d"
                            }
                        }
                    }
                }
            
            Button {
                viewModel.deleteConvo(withOtherUserUid: user.id ?? "")
            } label: {
                Image(systemName: "minus.circle")
                    .frame(width: 15, height: 15)
            }
        }
        .padding()

    }
}




