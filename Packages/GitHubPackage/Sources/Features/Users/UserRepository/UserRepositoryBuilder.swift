import GitHubCore

enum UserRepositoryBuilder {
    @MainActor
    static func build(with user: User) -> UserRepositoryScreen {
        .init(store: .init(
            userReposRepository: UserReposDefaultRepository(),
            user: user
        ))
    }
}
