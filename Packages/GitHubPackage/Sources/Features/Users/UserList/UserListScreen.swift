import GitHubCore
import SettingsFeature
import SwiftUI
import UICore

package struct UserListScreen: View {
    @Bindable var store: UsersScreenStore

    package var body: some View {
        UserListScreenContent(
            users: store.users,
            nextPage: store.nextPage,
            error: store.error,
            onAppear: {
                Task { await store.fetchFirstPage() }
            },
            onRefresh: {
                Task { await store.fetchFirstPage() }
            },
            onBottomReach: {
                Task { await store.fetchNextPage() }
            },
            onSettingsTap: store.onSettingsTap,
            onErrorAlertDismiss: store.onErrorAlertDismiss,
            isSetPresented: $store.isSetPresented
        )
    }
}

private struct UserListScreenContent: View {
    let users: [User]
    let nextPage: Page?
    let error: AppError?

    let onAppear: () -> Void
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
                        NavigationLink {
                            UserRepositoryBuilder.build(with: user)
                        } label: {
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
            .onAppear(perform: onAppear)
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
        onAppear: {},
        onRefresh: {},
        onBottomReach: {},
        onSettingsTap: {},
        onErrorAlertDismiss: {},
        isSetPresented: .init(get: { false }, set: { _ in })
    )
}
