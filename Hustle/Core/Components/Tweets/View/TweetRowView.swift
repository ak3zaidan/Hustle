import SwiftUI
import Kingfisher

struct TweetRowView: View {
    @ObservedObject var viewModel: TweetRowViewModel
    @State var dateFinal: String = ""
    @State private var isShowing: Bool = false
    @State private var response = ""
    
    init(tweet: Tweet){
        self.viewModel = TweetRowViewModel(tweet: tweet)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            
            //profile image + user info + tweet
            if let user = viewModel.tweet.user{
                
                HStack(alignment: .top, spacing: 12){
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .frame(width:56, height: 56)
                        .clipShape(Circle())
                        .scaledToFill()
                    //user info and tweet caption
                    VStack(alignment: .leading, spacing: 4){
                        //user info
                        HStack{
                            Text(user.fullname)
                                .font(.subheadline).bold()
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                                .font(.caption)
                            Text(dateFinal)
                                .foregroundColor(.gray)
                                .font(.caption)
                                .onReceive(viewModel.$tweet) { tweet in
                                    let dateString = viewModel.tweet.timestamp.dateValue().formatted(.dateTime.month().day().year().hour().minute())
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                    dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
                                    if let date = dateFormatter.date(from:dateString){
                                        if Calendar.current.isDateInToday(date){
                                            dateFinal = viewModel.tweet.timestamp.dateValue().formatted(.dateTime.hour().minute())}
                                        else if Calendar.current.isDateInYesterday(date) {dateFinal = "Yesterday"}
                                        else{
                                            if let dayBetween  = Calendar.current.dateComponents([.day], from: viewModel.tweet.timestamp.dateValue(), to: Date()).day{
                                                dateFinal = String(dayBetween + 1) + "d"
                                            }
                                        }
                                    }
                                }
                        }
                        Text(viewModel.tweet.caption)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                //action button on each tweet
                HStack(spacing: 50){
                    Button {
                        isShowing.toggle()
                    } label: {
                        HStack(spacing: 2){
                            Text("\(viewModel.tweet.comments)")
                            Image(systemName: "bubble.left")
                                .font(.subheadline)
                        }
                    }
                    .sheet(isPresented: $isShowing) {
                        ZStack(alignment: .top){
                            VStack(){
                                Text("Replying To:")
                                    .foregroundColor(.black)
                                    .padding(.top, 8)
                                HStack{
                                    Text(user.fullname)
                                        .font(.headline).bold()
                                        .foregroundColor(.black)
                                    Text("@\(user.username)")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }.padding(.top, 14)
                                Text(viewModel.tweet.caption)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.black)
                                    .padding(.top, 2)
                                HStack{
                                    TextArea("Reply...", text: $response)
                                        .frame(width: 275, height: 100, alignment: .leading)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(.gray, lineWidth: 2)
                                        }
                                    Button {
                                        //viewModel.uploadComment()
                                        //isShowing.toggle
                                        //haptic success
                                    } label: {
                                        Text("Comment")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                    }
                                    .frame(width: 80, height: 30)
                                    .background(Color.blue)
                                    .clipShape(Capsule())
                                }
                                Spacer()
                            }
                            .padding(.top, 15)
                            .presentationDetents([.fraction(0.3), .large])
                        }
                    }
                    
                    Button {
                        viewModel.tweet.didLike ?? false ?
                        viewModel.unlikeTweet() :
                        viewModel.likeTweet()
                    } label: {
                        HStack(spacing: 2){
                            Text("\(viewModel.tweet.likes)")
                            Image(systemName: viewModel.tweet.didLike ?? false ? "heart.fill" : "heart")
                                .font(.subheadline)
                                .foregroundColor(viewModel.tweet.didLike ?? false ? .red : .gray)
                        }
                    }
                }
                .padding()
                .foregroundColor(.gray)
                Divider()
            }
        }
    }
}

