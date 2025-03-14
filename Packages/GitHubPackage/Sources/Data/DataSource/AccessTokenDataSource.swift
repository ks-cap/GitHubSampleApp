import KeychainAccessCore

package protocol AccessTokenLocalDataSource: Sendable {
    func fetch() async throws -> String?
    func update(token: String) async throws
}

package struct AccessTokenDataSource {
    private let localDataSource: KeychainAccessClient

    package init(localDataSource: KeychainAccessClient) {
        self.localDataSource = localDataSource
    }
}

extension AccessTokenDataSource: AccessTokenLocalDataSource {
    package func fetch() async throws -> String? {
        try await localDataSource.get()
    }

    package func update(token: String) async throws {
        try await localDataSource.set(token)
    }
}
