import SwiftUI

enum UsersBuilder {
    @MainActor
    public static func build() -> UsersScreen {
        .init(store: .init(usersFetchInteractor: UsersFetchInteractor()))
    }
}
