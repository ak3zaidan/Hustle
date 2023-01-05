import SwiftUI

struct MessagesHomeView: View {
    @StateObject var viewModel = MessageViewModel()
    
    var body: some View {
        VStack{
            Text("Messages")
                .font(.title).bold()
                .padding(.leading, -170)
            
            
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
                
            
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.conversations){ user in
                        NavigationLink{
                            MessagesView(user: user)
                        } label: {
                            TitleRow(user: user)
                        }
                        Divider()
                    }
                }
            }
        }
    }
}


