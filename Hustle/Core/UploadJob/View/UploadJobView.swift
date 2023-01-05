import SwiftUI
import Kingfisher

struct UploadJobView: View {
    @State private var caption = ""
    @State private var zipCode = ""
    @State private var jobImageUrl = ""
    @State private var price = ""
    @State private var State = ""
    @State private var remote: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = UploadJobViewModel()
    @State var remoteIsSel: Bool = false
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
                
                Button { // add checks to make sure job is fine
                    viewModel.uploadJob(withCaption: caption, withZipCode: zipCode, withJobImageUrl: jobImageUrl, withPrice: price, withState: State, withRemote: remote)
                } label: {
                    Text("job")
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
                VStack{
                    TextArea("Whats happening", text: $caption)
                        .frame(height: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                    TextArea("photo", text: $jobImageUrl)
                        .frame(width: 150, height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                    Button{
                        remoteIsSel.toggle()
                        remote.toggle()
                    } label: {
                        Text(remoteIsSel ? "remote" : "not remote")
                    }
                    if !remoteIsSel {
                        TextArea("state", text: $State)
                            .frame(width: 150, height: 40)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray, lineWidth: 2)
                            }
                        TextArea("enter zipCode", text: $zipCode)
                            .frame(width: 150, height: 40)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray, lineWidth: 2)
                            }
                    }
                    TextArea("price", text: $price)
                        .frame(width: 150, height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                }
                .padding(.bottom, remoteIsSel ? 396 : 300)
            }
            .padding()
        }
        .onReceive(viewModel.$didUploadJob) { success in
            if success{
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct UploadJobView_Previews: PreviewProvider {
    static var previews: some View {
        UploadJobView()
            .environmentObject(AuthViewModel())
    }
}
