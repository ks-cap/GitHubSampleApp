protocol UserRepositoryFetchUseCase: Sendable {
    func fetch(username: String, nextPage: Page?) async throws -> (repositories: [UserRepository], nextPage: Page?)
}

final class UserRepositoryFetchInteractor: UserRepositoryFetchUseCase {
    private let client: APIClient
    
    init(client: APIClient = APIClientLive()) {
        self.client = client
    }
    
    func fetch(username: String, nextPage: Page?) async throws -> (repositories: [UserRepository], nextPage: Page?) {
        let request = UserRepositoryFetchRequest(username: username, page: nextPage)
        let response = try await client.perform(request: request)
        return (
            repositories: response.response.filter { !$0.fork },
            nextPage: response.nextPage
        )
    }
}
