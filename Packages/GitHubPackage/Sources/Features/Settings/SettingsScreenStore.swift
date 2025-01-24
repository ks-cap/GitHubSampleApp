import Foundation
import GitHubCore

@MainActor
@Observable
final class SettingsScreenStore {
    private let accessTokenRepository: AccessTokenRepository

    private(set) var currentAccessToken: String?

    var draftAccessToken: String

    init(accessTokenRepository: AccessTokenRepository) {
        self.accessTokenRepository = accessTokenRepository
        self.currentAccessToken = ""
        self.draftAccessToken = ""
    }

    func fetchAccessToken() async {
        currentAccessToken = await accessTokenRepository.fetch()
    }

    func updateAccessToken() async {
        await accessTokenRepository.update(token: draftAccessToken)
    }
}
