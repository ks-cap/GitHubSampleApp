/// @mockable
protocol AccessTokenFetchUseCase: Sendable {
    func execute() async -> String?
}

final class AccessTokenFetchInteractor: AccessTokenFetchUseCase {
    private let store: AccessTokenStore

    init(store: AccessTokenStore = .shared) {
        self.store = store
    }

    func execute() async -> String? {
        await store.get()
    }
}
