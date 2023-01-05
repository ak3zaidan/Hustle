import SwiftUI
import Kingfisher

struct JobsRowView: View {
    @ObservedObject var viewModel: JobsRowViewModel
    @State var dateFinal: String = ""
    static let myColor = Color("lightgray")
    
    init(job: Job){
        self.viewModel = JobsRowViewModel(job: job)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            
            //profile image + user info + tweet
            if let user = viewModel.job.user{
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
                                .onReceive(viewModel.$job) { jobs in
                                    let dateString = viewModel.job.timestamp.dateValue().formatted(.dateTime.month().day().year().hour().minute())
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                    dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
                                    if let date = dateFormatter.date(from:dateString){
                                        if Calendar.current.isDateInToday(date){
                                            dateFinal = viewModel.job.timestamp.dateValue().formatted(.dateTime.hour().minute())}
                                        else if Calendar.current.isDateInYesterday(date) {dateFinal = "Yesterday"}
                                        else{
                                            if let dayBetween  = Calendar.current.dateComponents([.day], from: viewModel.job.timestamp.dateValue(), to: Date()).day{
                                                dateFinal = String(dayBetween + 1) + "d"
                                            }
                                        }
                                    }
                                }
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 60, height: 20)
                                .foregroundColor(JobsRowView.myColor)
                                .overlay(Text(viewModel.job.remote ? "Remote" : "Local").font(.caption))
                        }
                        Text(viewModel.job.caption)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                //action button on each tweet
                HStack{
                    NavigationLink {
                        MessagesView(user: user)
                    } label: {
                        Image(systemName: "message")
                            .font(.subheadline)
                    }
                }
                .padding()
                .foregroundColor(.gray)
                Divider()
            }
        }
    }
}


