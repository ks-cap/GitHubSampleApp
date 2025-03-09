import Entity

package protocol UsersRepository: Sendable {
    func fetch() async throws -> (users: [User], nextPage: Page?)
    func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?)
}

extension UsersRepository {
    package func fetch() async throws -> (users: [User], nextPage: Page?) {
        try await fetch(with: nil)
    }
}
