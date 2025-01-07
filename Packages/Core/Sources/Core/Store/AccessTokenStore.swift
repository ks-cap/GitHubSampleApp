import Foundation
import KeychainAccess

actor AccessTokenStore: Sendable {
    static let shared = AccessTokenStore(
        keychain: .init(service: Const.service)
            .accessibility(.whenUnlockedThisDeviceOnly)
    )

    private enum Const {
        static let service = Bundle.main.bundleIdentifier! + ".api"
        static let accessToken = "token"
    }

    private let keychain: Keychain

    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    func get() -> String? {
        try? keychain.get(Const.accessToken)
    }
    
    func set(_ token: String) {
        try? keychain.set(token, key: Const.accessToken)
    }
}
