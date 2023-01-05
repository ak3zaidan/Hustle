import SwiftUI
import Kingfisher

struct ContentView: View {
    @State var selTab: Bool = false
    @State private var showMenu = false
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession == nil {
                LogInView()
            } else {
                mainInterFaceView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

extension ContentView{
    var mainInterFaceView: some View{
        ZStack(alignment: .topLeading){
            MainTabView(selTab: $selTab)
                .navigationBarHidden(showMenu || selTab ? false : true)
            
            if showMenu{
                ZStack{
                    Color(.black)
                        .opacity(showMenu ? 0.25 : 0.0)
                }.onTapGesture {
                    withAnimation(.easeInOut){
                        showMenu = false
                    }
                }
                .ignoresSafeArea()
            }
        
            SideMenuView()
                .frame(width: 300)
                .offset(x: showMenu ? 0 : -300, y: 0)
                .background(showMenu ? Color.white : Color.clear)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                if selTab == true {
                    Button {
                        withAnimation(.easeInOut){
                            showMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear{
            showMenu = false
        }
    }
}
