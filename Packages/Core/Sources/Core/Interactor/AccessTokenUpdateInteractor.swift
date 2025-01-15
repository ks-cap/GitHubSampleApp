/// @mockable
protocol AccessTokenUpdateUseCase: Sendable {
    func execute(with token: String) async
}

final class AccessTokenUpdateInteractor: AccessTokenUpdateUseCase {
    private let store: AccessTokenStore

    init(store: AccessTokenStore = .shared) {
        self.store = store
    }

    func execute(with token: String) async {
        await store.set(token)
    }
}
