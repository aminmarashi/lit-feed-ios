import SwiftUI

struct ProfileView: View {
    let user: User

    var body: some View {
        VStack {
          Spacer()
            AsyncImage(url: URL(string: user.picture))
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .padding()
            Text(user.email)
          Spacer()
        }
    }
}

#Preview {
  ProfileView(user: User(id: "id", email: "email", picture: "picture"))
}
