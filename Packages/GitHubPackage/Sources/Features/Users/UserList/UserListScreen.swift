import Model
import SettingsFeature
import SwiftUI

package struct UserListScreen: View {
    @Bindable var store: UsersScreenStore

    package var body: some View {
        UserListScreenContent(
            users: store.users,
            nextPage: store.nextPage,
            onAppear: {
                Task { await store.fetchFirstPage() }
            },
            onRefresh: {
                Task { await store.fetchFirstPage() }
            },
            onBottomReach: {
                Task { await store.fetchNextPage() }
            },
            onSettingsTap: store.onSettingsTapped,
            error: $store.error,
            isSetPresented: $store.isSetPresented
        )
    }
}

private struct UserListScreenContent: View {
    let users: [User]
    let nextPage: Page?

    let onAppear: () -> Void
    let onRefresh: () -> Void
    let onBottomReach: () -> Void
    let onSettingsTap: () -> Void

    @Binding var error: AppError?
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
            .alert(item: $error) {
                Alert(title: Text($0.error.localizedDescription))
            }
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
            .sheet(isPresented: $isSetPresented) {
                SettingsBuilder.build()
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

    UserListScreenContent(
        users: users,
        nextPage: nil,
        onAppear: {},
        onRefresh: {},
        onBottomReach: {},
        onSettingsTap: {},
        error: .init(get: { nil }, set: { _ in }),
        isSetPresented: .init(get: { false }, set: { _ in })
    )
}
