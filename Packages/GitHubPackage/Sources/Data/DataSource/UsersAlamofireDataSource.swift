import Entity

package protocol UsersRemoteDataSource: Sendable {
    func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?)
}

package struct UsersAlamofireDataSource {
    private let service: APIService
    
    package init(service: APIService = APIDefaultService()) {
        self.service = service
    }
}

extension UsersAlamofireDataSource: UsersRemoteDataSource {
    package func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?) {
        let request = UsersFetchRequest(page: nextPage)
        let response = try await service.perform(request: request)
        return (users: response.response.map { $0.toEntity() }, nextPage: response.nextPage)
    }
}
