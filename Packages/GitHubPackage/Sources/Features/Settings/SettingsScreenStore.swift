import Foundation
import GitHubCore

@MainActor
@Observable
final class SettingsScreenStore {
    private let accessTokenFetchUseCase: AccessTokenFetchUseCase
    private let accessTokenUpdateUseCase: AccessTokenUpdateUseCase

    private(set) var currentAccessToken: String?

    var draftAccessToken: String

    init(
        accessTokenFetchUseCase: AccessTokenFetchUseCase,
        accessTokenUpdateUseCase: AccessTokenUpdateUseCase
    ) {
        self.accessTokenFetchUseCase = accessTokenFetchUseCase
        self.accessTokenUpdateUseCase = accessTokenUpdateUseCase
        self.currentAccessToken = ""
        self.draftAccessToken = ""
    }

    func fetchAccessToken() async {
        currentAccessToken = await accessTokenFetchUseCase.execute()
    }

    func updateAccessToken() async {
        await accessTokenUpdateUseCase.execute(with: draftAccessToken)
    }
}
