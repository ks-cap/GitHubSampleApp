import Domain
import Entity

package final class UsersDefaultRepository {
    private let remoteDataSource: UsersRemoteDataSource
    
    package init(remoteDataSource: UsersRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
}

extension UsersDefaultRepository: UsersRepository {
    package func fetch(with nextPage: Page?) async throws -> (users: [User], nextPage: Page?) {
        try await remoteDataSource.fetch(with: nextPage)
    }
}
