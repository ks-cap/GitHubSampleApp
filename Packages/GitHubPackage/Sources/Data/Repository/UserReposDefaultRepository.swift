import Domain
import Entity

package struct UserReposDefaultRepository {
    private let remoteDataSource: UserReposRemoteDataSource
    
    package init(remoteDataSource: UserReposRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
}

extension UserReposDefaultRepository: UserReposRepository {
    package func fetch(username: String, nextPage: Page?) async throws -> (repos: [UserRepo], nextPage: Page?) {
        try await remoteDataSource.fetch(username: username, nextPage: nextPage)
    }
}
