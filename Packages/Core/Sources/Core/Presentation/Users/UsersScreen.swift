import SwiftUI

struct UsersScreen: View {
    @Bindable var store: UsersScreenStore
    
    var body: some View {        
        UsersScreenContent(
            users: store.users,
            nextPage: store.nextPage,
            onAppear: store.fetchFirstPage,
            onRefresh: store.fetchFirstPage,
            onBottomReach: store.fetchNextPage,
            error: $store.error
        )
    }
}

struct UsersScreenContent: View {
    var users: [User] = []
    var nextPage: Page?

    var onAppear: @Sendable () async -> Void = {}
    var onRefresh: @Sendable () async -> Void = {}
    var onBottomReach: @Sendable () async -> Void = {}

    @Binding var error: AppError?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(users) { user in
                        NavigationLink {
                            UserBuilder.build(with: user)
                        } label: {
                            UserRowView(user: user)
                        }
                    }
                    
                    if nextPage != nil {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .progressViewStyle(.automatic)
                            .task { await onBottomReach() }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .task { await onAppear() }
            .refreshable { await onRefresh() }
            .alert(item: $error) {
                Alert(title: Text($0.error.localizedDescription))
            }
        }
    }
}

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

#Preview {
    let users: [User] = (1...10).map { id in
        User(
            id: id,
            login: "User\(id)",
            reposUrl: "https://github.com/sample_user",
            avatarUrl: "https://placehold.jp/150x150.png"
        )
    }

    UsersScreenContent(
        users: users,
        nextPage: nil,
        onAppear: {},
        onRefresh: {},
        onBottomReach: {},
        error: .init(get: { nil }, set: { _ in })
    )
}
