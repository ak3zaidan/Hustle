import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        if viewModel.didAuthUser == true {
            ProfilePhotoSelectorView()
        } else {
            mainView
        }
    }
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel())
    }
}

extension RegistrationView{
    var mainView: some View {
        VStack{
            AuthHeaderView(title1: "Get Started", title2: "Create Your Account")
            VStack(spacing: 40){
                CustomTextField(imageName: "envelope",
                                placeHolderText: "Email",
                                text: $email)
                CustomTextField(imageName: "person",
                                placeHolderText: "Username",
                                text: $username)
                CustomTextField(imageName: "person",
                                placeHolderText: "Full Name",
                                text: $fullname)
                CustomTextField(imageName: "lock",
                                placeHolderText: "Password",
                                isSecureField: true,
                                text: $password)
            }
            .padding(32)
            
            Button {
                
                viewModel.register(withEmail: email,
                                   password: password,
                                   fullname: fullname,
                                   username: username,
                                   zipCode: "")
                
            } label: {
                Text("Sign up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Text("Already have an Account")
                        .font(.footnote)
                    Text("Sign in")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 32)
        }
        .ignoresSafeArea()
    }
}


    



