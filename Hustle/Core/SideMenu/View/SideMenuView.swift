import SwiftUI
import Kingfisher

struct SideMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        
        if let user = authViewModel.currentUser{
            VStack(alignment: .leading, spacing: 32){
                VStack(alignment: .leading){
                    
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading,spacing: 4){
                        Text(user.fullname)
                            .font(.headline)
                        Text("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    UserStats()
                        .padding(.vertical)
                }
                .padding(.leading)
                
                ForEach(SideMenuViewModel.allCases, id: \.rawValue){ viewModel in
                    if viewModel == .Account{
                        NavigationLink{
                            AccountView()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    }else if viewModel == .help{
                        NavigationLink{
                            HelpView()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    }else if viewModel == .logout{
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }

                    }else {
                        SideMenuOptionRowView(viewModel: viewModel)
                    }
                    
                }
                Spacer()
            }
        }
    }
}



