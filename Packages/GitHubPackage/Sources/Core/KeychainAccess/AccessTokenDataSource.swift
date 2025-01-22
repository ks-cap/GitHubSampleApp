import Foundation
import KeychainAccess

package protocol AccessTokenClient: Sendable {
    func get() async -> String?
    func set(_ token: String) async
}

// MARK: - AccessTokenClientLive

package actor AccessTokenClientLive {
    package static let shared = AccessTokenClientLive(
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

extension AccessTokenClientLive: AccessTokenClient {
    package func get() -> String? {
        try? keychain.get(Const.accessToken)
    }
    
    package func set(_ token: String) {
        try? keychain.set(token, key: Const.accessToken)
    }
}
