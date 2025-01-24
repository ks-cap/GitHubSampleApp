/// @mockable
package protocol UsersRepository: Sendable {
    func fetch() async throws -> (users: [User], nextPage: Page?)
    func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?)
}

extension UsersRepository {
    package func fetch() async throws -> (users: [User], nextPage: Page?) {
        try await fetch(with: nil)
    }
}

// MARK: - UsersDefaultRepository

package final class UsersDefaultRepository {
    private let service: APIService
    
    package init(service: APIService = APIDefaultService()) {
        self.service = service
    }
}

extension UsersDefaultRepository: UsersRepository {
    package func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?) {
        let request = UsersFetchRequest(page: nextPage)
        let response = try await service.perform(request: request)
        return (users: response.response, nextPage: response.nextPage)
    }
}
