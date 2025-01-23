import Model
import UseCase

enum UserRepositoryBuilder {
    @MainActor
    static func build(with user: User) -> UserRepositoryScreen {
        .init(store: .init(
            userRepositoryFetchUseCase: UserRepositoryFetchInteractor(),
            user: user
        ))
    }
}
