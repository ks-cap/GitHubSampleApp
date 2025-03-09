import Domain

package final class AccessTokenDefaultRepository {
    private let localDataSource: AccessTokenLocalDataSource
    
    package init(localDataSource: AccessTokenLocalDataSource = AccessTokenDataSource()) {
        self.localDataSource = localDataSource
    }
}

extension AccessTokenDefaultRepository: AccessTokenRepository {
    package func fetch() async throws -> String? {
        try await localDataSource.fetch()
    }

    package func update(token: String) async throws {
        try await localDataSource.update(token: token)
    }
}
