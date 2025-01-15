/// @mockable
protocol UsersFetchUseCase: Sendable {
    func execute() async throws -> (users: [User], nextPage: Page?)
    func execute(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?)
}

extension UsersFetchUseCase {
    func execute() async throws -> (users: [User], nextPage: Page?) {
        try await execute(with: nil)
    }

}

final class UsersFetchInteractor: UsersFetchUseCase {
    private let client: APIClient
    
    init(client: APIClient = APIClientLive()) {
        self.client = client
    }
    
    func execute(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?) {
        let request = UsersFetchRequest(page: nextPage)
        let response = try await client.perform(request: request)
        return (users: response.response, nextPage: response.nextPage)
    }
}
