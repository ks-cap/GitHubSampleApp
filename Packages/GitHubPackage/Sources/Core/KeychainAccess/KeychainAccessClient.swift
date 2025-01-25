import Foundation
import KeychainAccess

package protocol KeychainAccessClient: Sendable {
    func get() async throws -> String?
    func set(_ token: String) async throws
}

// MARK: - KeychainAccessDefaultClient

package actor KeychainAccessDefaultClient {
    package static let shared = KeychainAccessDefaultClient(
        keychain: .init(service: Const.service).accessibility(.whenUnlockedThisDeviceOnly)
    )

    private enum Const {
        static let service = Bundle.main.bundleIdentifier! + ".api"
        static let accessToken = "token"
    }

    private let keychain: Keychain

    private init(keychain: Keychain) {
        self.keychain = keychain
    }
}

extension KeychainAccessDefaultClient: KeychainAccessClient {
    package func get() throws -> String? {
        try keychain.get(Const.accessToken)
    }
    
    package func set(_ token: String) throws {
        try keychain.set(token, key: Const.accessToken)
    }
}
