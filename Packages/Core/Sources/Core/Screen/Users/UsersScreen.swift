import SwiftUI

struct UsersScreen: View {
    @StateObject var store: UsersScreenStore
    
    var body: some View {
        UsersScreenContent(
            users: store.users,
            isLoading: store.isLoading,
            onAppear: store.onAppear
        )
    }
}

struct UsersScreenContent: View {
    var users: [User]
    var isLoading: Bool

    var onAppear: @Sendable () async -> Void = {}
    var onRefresh: @Sendable () async -> Void = {}

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(users) { user in
                        UserRowView(user: user)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable { await onRefresh() }
        }
        .task { await onAppear() }
    }
}

private struct UserRowView: View {
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
        }
    }
}
