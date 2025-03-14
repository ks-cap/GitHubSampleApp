import DebugFeature
import Entity
import SettingsFeature
import UsersFeature

@MainActor
package enum ScreenFactory {
    package static func createDebugScreen() -> DebugScreen {
        .init()
    }

    package static func createUserListScreen() -> UserListScreen {
        .init(store: .init(usersRepository: RepositoryFactory.create()))
    }
    
    package static func createUserRepoScreen(user: User) -> UserRepoScreen {
        .init(store: .init(user: user, userReposRepository: RepositoryFactory.create()))
    }
    
    package static func createSettingsScreen() -> SettingsScreen {
        .init(store: .init(
            accessTokenRepository: RepositoryFactory.create(),
            validator: ValidatorFactory.create()
        ))
    }
}
