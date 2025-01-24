/// @mockable
package protocol UserReposRepository: Sendable {
    func fetch(username: String, nextPage: Page?) async throws -> (repositories: [UserRepository], nextPage: Page?)
}

// MARK: - UserReposDefaultRepository

package final class UserReposDefaultRepository {
    private let service: APIService
    
    package init(service: APIService = APIDefaultService()) {
        self.service = service
    }
}

extension UserReposDefaultRepository: UserReposRepository {
    package func fetch(username: String, nextPage: Page?) async throws -> (repositories: [UserRepository], nextPage: Page?) {
        let request = UserRepositoryFetchRequest(username: username, page: nextPage)
        let response = try await service.perform(request: request)
        return (
            repositories: response.response.filter { !$0.fork },
            nextPage: response.nextPage
        )
    }
}
