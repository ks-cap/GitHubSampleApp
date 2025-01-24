import KeychainAccessCore

/// @mockable
package protocol AccessTokenRepository: Sendable {
    func fetch() async -> String?
    func update(token: String) async
}

// MARK: - AccessTokenDefaultRepository

package final class AccessTokenDefaultRepository {
    private let client: KeychainAccessClient

    package init(client: KeychainAccessClient = KeychainAccessDefaultClient.shared) {
        self.client = client
    }
}

extension AccessTokenDefaultRepository: AccessTokenRepository {
    package func fetch() async -> String? {
        await client.get()
    }

    package func update(token: String) async {
        await client.set(token)
    }
}
