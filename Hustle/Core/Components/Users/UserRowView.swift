

import SwiftUI
import Kingfisher

struct UserRowView: View {
    
    let user: User
    var body: some View {
        HStack(spacing: 12){
            KFImage(URL(string: user.profileImageUrl))
                .resizable()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .scaledToFill()
            VStack(alignment: .leading, spacing: 4){
                Text(user.username)
                    .font(.subheadline).bold()
                    .foregroundColor(.black)
                Text(user.fullname)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserRowView(user: User(id: NSUUID().uuidString,
                               username: "ahmed",
                               fullname: "ahmed Zaidan",
                               profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/hustle-85b6c.appspot.com/o/profile_image%2FF547BF94-D387-4F29-856F-6C8BFD76B16A?alt=media&token=8d52c474-113c-4f28-bda6-1bb6922604f0",
                               email:"ahmed@gmail.com", zipCode: ""))
    }
}
