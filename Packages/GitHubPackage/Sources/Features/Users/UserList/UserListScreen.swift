import GitHubCore
import SettingsFeature
import SwiftUI
import UICore

package struct UserListScreen: View {
    @Bindable var store: UsersScreenStore

    package var body: some View {
        AsyncContentView(
            state: store.viewState,
            success: {
                UserListScreenContent(
                    users: $0,
                    nextPage: store.nextPage,
                    error: store.error,
                    onRefresh: {
                        Task { await store.refresh() }
                    },
                    onBottomReach: {
                        Task { await store.fetchNextPage() }
                    },
                    onSettingsTap: store.onSettingsTap,
                    onErrorAlertDismiss: store.onErrorAlertDismiss,
                    isSetPresented: $store.isSetPresented
                )
            },
            onRetryTap: {
                Task { await store.fetchFirstPage() }
            }
        )
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
    let onSettingsTap: () -> Void
    let onErrorAlertDismiss: () -> Void

    @Binding var isSetPresented: Bool

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(users) { user in
                        NavigationLink(destination: UserRepositoryBuilder.build(with: user)) {
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
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        onSettingsTap()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            })
            .navigationTitle("Users")
            .errorAlert(
                error: error,
                onDismiss: { onErrorAlertDismiss() }
            )
            .sheet(isPresented: $isSetPresented) {
                SettingsBuilder.build()
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
        error: nil,
        onRefresh: {},
        onBottomReach: {},
        onSettingsTap: {},
        onErrorAlertDismiss: {},
        isSetPresented: .init(get: { false }, set: { _ in })
    )
}
