package protocol UserRepositoryFetchUseCase: Sendable {
    func execute(username: String, nextPage: Page?) async throws -> (repositories: [UserRepository], nextPage: Page?)
}

// MARK: - UserRepositoryFetchInteractor

package final class UserRepositoryFetchInteractor {
    private let client: APIClient
    
    package init(client: APIClient = APIClientLive()) {
        self.client = client
    }
}

extension UserRepositoryFetchInteractor: UserRepositoryFetchUseCase {
    package func execute(username: String, nextPage: Page?) async throws -> (repositories: [UserRepository], nextPage: Page?) {
        let request = UserRepositoryFetchRequest(username: username, page: nextPage)
        let response = try await client.perform(request: request)
        return (
            repositories: response.response.filter { !$0.fork },
            nextPage: response.nextPage
        )
    }
}
