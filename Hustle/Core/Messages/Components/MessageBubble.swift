import SwiftUI

struct MessageBubble: View {
    @State private var showTime = false
    @ObservedObject var viewModel: BubbleViewModel
    
    init(message: Message){
        self.viewModel = BubbleViewModel(message: message)
    }
    
    var body: some View {
        VStack(alignment: viewModel.message.recieved ? .leading : .trailing){
            HStack{
                Text(viewModel.message.text)
                    .padding()
                    .background(viewModel.message.recieved ? Color("gray") : Color("pink"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: viewModel.message.recieved ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime{
                Text("\(viewModel.message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(viewModel.message.recieved ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: viewModel.message.recieved ? .leading : .trailing)
        .padding(viewModel.message.recieved ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "12345", recieved: false, seen: true, text: "", timestamp: Date()))
    }
}


