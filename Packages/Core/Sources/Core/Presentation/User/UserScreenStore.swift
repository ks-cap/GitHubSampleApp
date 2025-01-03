import Foundation

@MainActor
@Observable final class UserScreenStore {
    private let userRepositoryFetchInteractor: UserRepositoryFetchUseCase
    
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

    init(user: User, userRepositoryFetchInteractor: UserRepositoryFetchUseCase) {
        self.userRepositoryFetchInteractor = userRepositoryFetchInteractor
        self.user = user
        self.repositories = []
        self.isLoading = false
        self.url = nil
        self.error = nil
    }
    
    @Sendable func fetchFirstPage() async {
        guard !isLoading else { return }
        
        isLoading = true

        Task.detached {
            do {
                let response = try await self.userRepositoryFetchInteractor.fetch(
                    username: self.user.login,
                    nextPage: self.nextPage
                )
                await MainActor.run {
                    self.repositories = response.repositories
                    self.nextPage = response.nextPage
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.error = AppError(error: error)
                }
            }
        }
    }
    
    @Sendable func fetchNextPage() async {
        guard !isLoading, let nextPage else { return }
        
        isLoading = true

        Task.detached {
            do {
                let response = try await self.userRepositoryFetchInteractor.fetch(
                    username: self.user.login,
                    nextPage: nextPage
                )
                await MainActor.run {
                    self.repositories.append(contentsOf: response.repositories)
                    self.nextPage = response.nextPage
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.error = AppError(error: error)
                }
            }
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
