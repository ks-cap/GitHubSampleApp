import Foundation

@MainActor
@Observable final class UserScreenStore {
    private let userRepositoryFetchInteractor: UserRepositoryFetchUseCase
    
    private(set) var user: User
    private(set) var nextPage: Page?
    private(set) var repositories: [UserRepository]
    private(set) var isLoading: Bool
    private(set) var selectedUrl: URL?

    var error: AppError?
    var isShowSafari: Bool

    init(user: User, userRepositoryFetchInteractor: UserRepositoryFetchUseCase) {
        self.userRepositoryFetchInteractor = userRepositoryFetchInteractor
        self.user = user
        self.repositories = []
        self.isLoading = false
        self.selectedUrl = nil
        self.error = nil
        self.isShowSafari = false
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

                    guard let errorType = error as? AppErrorType else { return }
                    self.error = AppError(error: errorType)
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

                    guard let errorType = error as? AppErrorType else { return }
                    self.error = AppError(error: errorType)
                }
            }
        }
    }
    
    func selectRepositoryUrl(_ htmlUrl: String) {
        isShowSafari = true
        selectedUrl = URL(string: htmlUrl)
    }
}
