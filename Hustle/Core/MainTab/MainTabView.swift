import SwiftUI
import Combine

struct MainTabView: View {
    @Binding var selTab: Bool
    @State private var selectedTab = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        TabView(selection: $selectedTab){
            NavigationView(){
                FeedView()
            }
            .tabItem {
                Image(systemName: "h.circle")
            }.tag(1)
            NavigationView(){
                JobsView()
            }
            .tabItem {
                Image(systemName: "j.circle")
            }.tag(2)
            NavigationView(){
                ExploreView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
            }.tag(3)
            NavigationView(){
                MessagesHomeView()
            }
            .tabItem{
                Image(systemName: "message")
            }.tag(4)
            NavigationView(){
                if let user = authViewModel.currentUser{
                    ProfileView(user: user)
                }
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
            }.tag(5)
        }
        .onReceive(Just(selectedTab)) { _ in
            if selectedTab == 5{
                selTab = true
            } else {
                selTab = false
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(selTab: .constant(false))
            .environmentObject(AuthViewModel())
    }
}
