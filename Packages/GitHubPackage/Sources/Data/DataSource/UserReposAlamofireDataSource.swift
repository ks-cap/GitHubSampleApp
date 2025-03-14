import Entity

package protocol UserReposRemoteDataSource: Sendable {
    func fetch(username: String, nextPage: Page?) async throws -> (repos: [UserRepo], nextPage: Page?)
}

package struct UserReposAlamofireDataSource {
    private let service: APIService
    
    package init(service: APIService) {
        self.service = service
    }
}

extension UserReposAlamofireDataSource: UserReposRemoteDataSource {
    package func fetch(username: String, nextPage: Page?) async throws -> (repos: [UserRepo], nextPage: Page?) {
        let request = UserRepositoryFetchRequest(username: username, page: nextPage)
        let response = try await service.perform(request: request)
        return (
            repos: response.response.map { $0.toEntity() }.filter { !$0.fork },
            nextPage: response.nextPage
        )
    }
}
