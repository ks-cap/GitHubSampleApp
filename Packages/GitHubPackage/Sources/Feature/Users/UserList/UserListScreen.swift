import Entity
import Factory
import SettingsFeature
import SwiftUI
import UICore

package struct UserListScreen: View {
    @Bindable private var store: UserListScreenStore

    package init(store: UserListScreenStore) {
        self.store = store
    }

    package var body: some View {
        AsyncContentView(
            state: store.viewState,
            success: {
                UserListScreenContent(
                    users: $0,
                    nextPage: store.nextPage,
                    onRefresh: {
                        Task { await store.refresh() }
                    },
                    onBottomReach: {
                        Task { await store.fetchNextPage() }
                    }
                )
            },
            onAppear: {
                Task { await store.fetchFirstPage() }
            },
            onRetryTap: {
                Task { await store.fetchFirstPage() }
            }
        )
        .errorAlert(
            error: store.error,
            onDismiss: store.onErrorAlertDismiss
        )
    }
}

private struct UserListScreenContent: View {
    let users: [User]
    let nextPage: Page?

    let onRefresh: () -> Void
    let onBottomReach: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(users) { user in
                        NavigationLink(value: user) {
                            UserRowView(user: user)
                        }
                    }
                    
                    if nextPage != nil {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .progressViewStyle(.automatic)
                            .task { onBottomReach() }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable { onRefresh() }
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                ScreenFactory.createUserRepoScreen(user: user)
            }
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

    UserListScreenContent(
        users: users,
        nextPage: nil,
        onRefresh: {},
        onBottomReach: {}
    )
}
