import Foundation

@MainActor
@Observable
final class SettingsScreenStore {
    private let accessTokenFetchInteractor: AccessTokenFetchUseCase
    private let accessTokenUpdateInteractor: AccessTokenUpdateUseCase

    private(set) var currentAccessToken: String?

    var draftAccessToken: String

    init(
        accessTokenFetchInteractor: AccessTokenFetchUseCase,
        accessTokenUpdateInteractor: AccessTokenUpdateUseCase
    ) {
        self.accessTokenFetchInteractor = accessTokenFetchInteractor
        self.accessTokenUpdateInteractor = accessTokenUpdateInteractor
        self.currentAccessToken = ""
        self.draftAccessToken = ""
    }

    func fetchAccessToken() async {
        currentAccessToken = await accessTokenFetchInteractor.execute()
    }

    func updateAccessToken() async {
        await accessTokenUpdateInteractor.execute(with: draftAccessToken)
    }
}
