import API
import Model

package protocol UsersFetchUseCase: Sendable {
    func execute() async throws -> (users: [User], nextPage: Page?)
    func execute(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?)
}

extension UsersFetchUseCase {
    package func execute() async throws -> (users: [User], nextPage: Page?) {
        try await execute(with: nil)
    }
}

// MARK: - UsersFetchInteractor

package final class UsersFetchInteractor {
    private let client: APIClient
    
    package init(client: APIClient = APIClientLive()) {
        self.client = client
    }
}

extension UsersFetchInteractor: UsersFetchUseCase {
    package func execute(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?) {
        let request = UsersFetchRequest(page: nextPage)
        let response = try await client.perform(request: request)
        return (users: response.response, nextPage: response.nextPage)
    }
}
