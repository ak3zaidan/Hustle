import SwiftUI
import Kingfisher

struct NewTweetView: View {
    @State private var caption = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = UploadTweetViewModel()
    var body: some View {
        VStack{
            HStack{
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color(.systemBlue))
                }
                
                Spacer()
                
                Button {
                    viewModel.uploadTweet(withCaption: caption)
                } label: {
                    Text("tweet")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                }

            }
            .padding()
            
            HStack(alignment: .top){
                if let user = authViewModel.currentUser{
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .frame(width: 64, height: 64)
                        .scaledToFill()
                        .clipShape(Circle())
                }
                TextArea("Whats happening", text: $caption)
            }
            .padding()
        }
        .onReceive(viewModel.$didUploadTweet) { success in
            if success{
                presentationMode.wrappedValue.dismiss()
            } // logic here to tell user reason if tweet upload failed
        }
    }
}

struct NewTweetView_Previews: PreviewProvider {
    static var previews: some View {
        NewTweetView()
            .environmentObject(AuthViewModel())
    }
}
