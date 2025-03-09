import Entity

package protocol UserReposRepository: Sendable {
    func fetch(username: String, nextPage: Page?) async throws -> (repos: [UserRepo], nextPage: Page?)
}

extension UserReposRepository {
    package func fetch(username: String) async throws -> (repos: [UserRepo], nextPage: Page?) {
        try await fetch(username: username, nextPage: nil)
    }
}
