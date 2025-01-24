import SwiftUI
import GitHubCore

package enum SettingsBuilder {
    @MainActor
    package static func build() -> SettingsScreen {
        .init(store: .init(
            accessTokenFetchUseCase: AccessTokenFetchInteractor(),
            accessTokenUpdateUseCase: AccessTokenUpdateInteractor()
        ))
    }
}
