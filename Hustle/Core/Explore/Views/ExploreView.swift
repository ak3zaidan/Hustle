import SwiftUI

struct ExploreView: View {
    @ObservedObject var viewModel = ExploreViewModel()
    var body: some View {
        
        VStack{
            SearchBar(text: $viewModel.searchText)
                .padding()
            
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.searchableUsers){ user in
                        NavigationLink{
                            ProfileView(user: user)
                        } label: {
                            UserRowView(user: user)
                        }
                    }
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
