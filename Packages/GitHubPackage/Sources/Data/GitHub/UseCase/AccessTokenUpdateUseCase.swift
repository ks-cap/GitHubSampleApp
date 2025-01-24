import KeychainAccessCore

package protocol AccessTokenUpdateUseCase: Sendable {
    func execute(with token: String) async
}

// MARK: - AccessTokenUpdateInteractor

package final class AccessTokenUpdateInteractor {
    private let client: AccessTokenClient

    package init(client: AccessTokenClient = AccessTokenClientLive.shared) {
        self.client = client
    }
}

extension AccessTokenUpdateInteractor: AccessTokenUpdateUseCase {
    package func execute(with token: String) async {
        await client.set(token)
    }
}
