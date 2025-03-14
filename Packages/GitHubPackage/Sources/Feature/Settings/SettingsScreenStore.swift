import Data
import Domain
import Entity
import Foundation

@MainActor
@Observable
package final class SettingsScreenStore {
    private let accessTokenRepository: AccessTokenRepository
    private let validator: GitHubValidator

    private(set) var hasAccessToken: Bool
    private(set) var error: Error?

    var isAccessTokenPresented: Bool
    var accessToken: String

    package init(
        accessTokenRepository: AccessTokenRepository,
        validator: GitHubValidator
    ) {
        self.accessTokenRepository = accessTokenRepository
        self.validator = validator
        self.hasAccessToken = false
        self.error = nil
        self.isAccessTokenPresented = false
        self.accessToken = ""
    }

    func fetchAccessToken() async {
        do {
            let currentAccessToken = try await accessTokenRepository.fetch()
            
            hasAccessToken = currentAccessToken?.isEmpty == false
        } catch {
            self.error = error
        }
    }

    func updateAccessToken() async {
//        guard validator.validate(accessToken: accessToken) else {
//            return
//        }

        do {
            try await accessTokenRepository.update(token: accessToken)
            
            hasAccessToken = !accessToken.isEmpty
            isAccessTokenPresented = true
        } catch {
            self.error = error
        }
    }
    
    func onErrorAlertDismiss() {
        error = nil
    }
}
