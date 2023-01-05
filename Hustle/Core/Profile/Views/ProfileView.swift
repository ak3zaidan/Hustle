import SwiftUI
import Kingfisher

struct ProfileView: View {
    @State private var selectedFilter: TweetFilterViewModel = .tweets
    @Environment(\.presentationMode) var mode
    @State private var showMenu = false
    @ObservedObject var viewModel: ProfileViewModel
    @Namespace var animation
    @EnvironmentObject var viewerModel: AuthViewModel
    
    init(user: User){
        self.viewModel = ProfileViewModel(user: user)
    }
    var body: some View {
        VStack(alignment: .leading){
            
            headerView
            actionButtons
            userInfoDetails
            tweetFilter
            tweetsView
            
            Spacer()
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(id: NSUUID().uuidString,
                               username: "ahmed",
                               fullname: "ahmed Zaidan",
                               profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/hustle-85b6c.appspot.com/o/profile_image%2FF547BF94-D387-4F29-856F-6C8BFD76B16A?alt=media&token=8d52c474-113c-4f28-bda6-1bb6922604f0",
                               email:"ahmed@gmail.com", zipCode: ""))
        .environmentObject(AuthViewModel())
    }
}



extension ProfileView{
    var headerView: some View {
        ZStack(alignment: .bottomLeading){
            Color(.systemBlue)
                .ignoresSafeArea()
            VStack{
                KFImage(URL(string: viewModel.user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 72, height: 72)
                    .offset(x: 16,y:24)
            }
        }
        .frame(height: 96)
    }
    var actionButtons: some View{
        HStack{
            Spacer()
            
            NavigationLink{
                MessagesView(user: viewModel.user)
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .padding(6)
                    .overlay(Circle().stroke(Color.gray,lineWidth: 0.75))
            }
            Button {
                
            } label: {
                Text(viewModel.actionButtonTitle)
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 32)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
            }

        }
        .padding(.trailing)
    }
    
    var userInfoDetails: some View{
        VStack(alignment: .leading, spacing: 4){
            HStack{
                Text(viewModel.user.fullname)
                    .font(.title2).bold()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemBlue))
            }
            
            Text("@\(viewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("hello")
                .font(.subheadline)
                .padding(.vertical)
            
            HStack(spacing: 24){
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                    Text("portland Or")
                }
                HStack{
                    Image(systemName: "link")
                    Text("www.Ahmed")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            UserStats()
            
            .padding(.vertical)
            
        }
        .padding(.horizontal)
    }
    
    var tweetFilter: some View{
        HStack{
            ForEach(TweetFilterViewModel.allCases, id: \.rawValue){ item in
                VStack{
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold: .regular)
                        .foregroundColor(selectedFilter == item ? .black:.gray)
                    
                    if selectedFilter == item{
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut){
                        self.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x:0, y:16))
    }
    
    var tweetsView: some View{
        ScrollView{
            LazyVStack{
                ForEach(viewModel.tweets(forFilter: self.selectedFilter)){ tweet in
                    TweetRowView(tweet: tweet)
                       .padding()
                }
            }
        }
    }
}
