import KeychainAccessCore

/// @mockable
package protocol AccessTokenRepository: Sendable {
    func fetch() async throws -> String?
    func update(token: String) async throws
}

// MARK: - AccessTokenDefaultRepository

package final class AccessTokenDefaultRepository {
    private let client: KeychainAccessClient

    package init(client: KeychainAccessClient = KeychainAccessDefaultClient.shared) {
        self.client = client
    }
}

extension AccessTokenDefaultRepository: AccessTokenRepository {
    package func fetch() async throws -> String? {
        try await client.get()
    }

    package func update(token: String) async throws {
        try await client.set(token)
    }
}
