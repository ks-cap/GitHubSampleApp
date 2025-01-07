import SwiftUI

enum SettingsBuilder {
    @MainActor
    static func build() -> SettingsScreen {
        .init(store: .init(
            accessTokenFetchInteractor: AccessTokenFetchInteractor(),
            accessTokenUpdateInteractor: AccessTokenUpdateInteractor()
        ))
    }
}
