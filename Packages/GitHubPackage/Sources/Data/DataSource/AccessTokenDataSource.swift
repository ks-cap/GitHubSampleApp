import KeychainAccessCore

package protocol AccessTokenLocalDataSource: Sendable {
    func fetch() async throws -> String?
    func update(token: String) async throws
}

package struct AccessTokenDataSource {
    private let client: KeychainAccessClient

    package init(client: KeychainAccessClient = KeychainAccessDefaultClient.shared) {
        self.client = client
    }
}

extension AccessTokenDataSource: AccessTokenLocalDataSource {
    package func fetch() async throws -> String? {
        try await client.get()
    }

    package func update(token: String) async throws {
        try await client.set(token)
    }
}
