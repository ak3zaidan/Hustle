import SwiftUI
import Firebase

@main
struct HustleApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
            .environmentObject(viewModel)
        }
    }
}
