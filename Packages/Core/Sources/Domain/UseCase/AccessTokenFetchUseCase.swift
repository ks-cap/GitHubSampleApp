import KeychainAccessCore

package protocol AccessTokenFetchUseCase: Sendable {
    func execute() async -> String?
}

// MARK: - AccessTokenFetchInteractor

package final class AccessTokenFetchInteractor: Sendable {
    private let client: AccessTokenClient

    package init(client: AccessTokenClient = AccessTokenClientLive.shared) {
        self.client = client
    }
}

extension AccessTokenFetchInteractor: AccessTokenFetchUseCase {
    package func execute() async -> String? {
        await client.get()
    }
}
