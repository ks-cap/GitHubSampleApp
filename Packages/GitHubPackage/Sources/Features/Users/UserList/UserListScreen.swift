import GitHubCore
import SettingsFeature
import SwiftUI
import UICore

package struct UserListScreen: View {
    @Bindable private var store: UsersScreenStore

    package init(store: UsersScreenStore) {
        self.store = store
    }

    package var body: some View {
        // Workaround
        UserListScreenContent(
            users: store.viewState.value ?? [],
            nextPage: store.nextPage,
            error: store.error,
            onRefresh: {
                Task { await store.refresh() }
            },
            onBottomReach: {
                Task { await store.fetchNextPage() }
            },
            onErrorAlertDismiss: store.onErrorAlertDismiss
        )
//        AsyncContentView(
//            state: store.viewState,
//            success: {
//                UserListScreenContent(
//                    users: $0,
//                    nextPage: store.nextPage,
//                    error: store.error,
//                    onRefresh: {
//                        Task { await store.refresh() }
//                    },
//                    onBottomReach: {
//                        Task { await store.fetchNextPage() }
//                    },
//                    onErrorAlertDismiss: store.onErrorAlertDismiss
//                )
//            },
//            onRetryTap: {
//                Task { await store.fetchFirstPage() }
//            }
//        )
        .task {
            await store.fetchFirstPage()
        }
    }
}

private struct UserListScreenContent: View {
    let users: [User]
    let nextPage: Page?
    let error: AppError?

    let onRefresh: () -> Void
    let onBottomReach: () -> Void
    let onErrorAlertDismiss: () -> Void

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
                            .onAppear(perform: onBottomReach)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable { onRefresh() }
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                UserRepositoryBuilder.build(with: user)
            }
            .errorAlert(
                error: error,
                onDismiss: { onErrorAlertDismiss() }
            )
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
        error: nil,
        onRefresh: {},
        onBottomReach: {},
        onErrorAlertDismiss: {}
    )
}
