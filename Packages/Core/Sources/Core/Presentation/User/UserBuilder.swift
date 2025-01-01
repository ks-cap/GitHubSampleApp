import SwiftUI

enum UserBuilder {
    @MainActor
    public static func build(with user: User) -> UserScreen {
        .init(store: .init(user: user, userRepositoryFetchInteractor: UserRepositoryFetchInteractor()))
    }
}
