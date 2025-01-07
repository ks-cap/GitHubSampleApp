import SwiftUI

enum UsersBuilder {
    @MainActor
    static func build() -> UsersScreen {
        .init(store: .init(usersFetchInteractor: UsersFetchInteractor()))
    }
}
