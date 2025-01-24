import GitHubCore

package enum UserListBuilder {
    @MainActor
    package static func build() -> UserListScreen {
        .init(store: .init(usersRepository: UsersDefaultRepository()))
    }
}
