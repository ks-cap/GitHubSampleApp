protocol UsersFetchUseCase: Sendable {
    func fetch() async throws -> (users: [User], nextPage: Page?)
    func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?)
}

extension UsersFetchUseCase {
    func fetch() async throws -> (users: [User], nextPage: Page?) {
        try await fetch(with: nil)
    }

}

final class UsersFetchInteractor: UsersFetchUseCase {
    private let client: APIClient
    
    init(client: APIClient = APIClientLive()) {
        self.client = client
    }
    
    func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?) {
        let request = UsersFetchRequest()
        let response = try await client.perform(request: request, nextPage: nextPage)
        return (users: response.response, nextPage: response.nextPage)
    }
}
