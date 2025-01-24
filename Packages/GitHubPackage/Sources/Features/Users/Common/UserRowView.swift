import GitHubCore
import SwiftUI

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(
                url:  URL(string: user.avatarUrl),
                content: { $0.resizable() },
                placeholder: { ProgressView() }
            )
            .clipShape(Circle())
            .frame(width: 28, height: 28)
            
            Text(user.login)
                .foregroundStyle(.primary)
                .font(.body)
        }
    }
}
