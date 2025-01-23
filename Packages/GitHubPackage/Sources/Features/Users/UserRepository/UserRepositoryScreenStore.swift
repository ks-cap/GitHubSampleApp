import Foundation
import Model
import UseCase

@MainActor
@Observable
final class UserRepositoryScreenStore {
    private let userRepositoryFetchUseCase: UserRepositoryFetchUseCase
    
    private(set) var user: User
    private(set) var nextPage: Page?
    private(set) var repositories: [UserRepository]
    private(set) var isLoading: Bool

    var error: AppError?
    var url: SelectUrl?

    struct SelectUrl: Identifiable {
        let id = UUID()
        let url: URL
    }

    init(
        userRepositoryFetchUseCase: UserRepositoryFetchUseCase,
        user: User
    ) {
        self.userRepositoryFetchUseCase = userRepositoryFetchUseCase
        self.user = user
        self.repositories = []
        self.isLoading = false
        self.url = nil
        self.error = nil
    }
    
    @Sendable func fetchFirstPage() async {
        guard !isLoading else { return }
        
        isLoading = true

        do {
            let response = try await userRepositoryFetchUseCase.execute(username: user.login, nextPage: nextPage)
            
            isLoading = false
            repositories = response.repositories
            nextPage = response.nextPage
        } catch {
            isLoading = false
            self.error = AppError(error: error)
        }
    }
    
    @Sendable func fetchNextPage() async {
        guard !isLoading, let nextPage else { return }
        
        isLoading = true

        do {
            let response = try await userRepositoryFetchUseCase.execute(username: user.login, nextPage: nextPage)
            
            isLoading = false
            repositories.append(contentsOf: response.repositories)
            self.nextPage = response.nextPage
        } catch {
            isLoading = false
            self.error = AppError(error: error)
        }
    }
    
    func selectRepository(_ repository: UserRepository) {
        do {
            let url = try repository.url
            self.url = .init(url: url)
        } catch {
            self.error = AppError(error: error)
        }
    }
}
