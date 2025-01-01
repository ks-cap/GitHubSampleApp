import Foundation

@MainActor
@Observable final class UsersScreenStore {
    private let usersFetchInteractor: UsersFetchUseCase

    private(set) var users: [User]
    private(set) var isLoading: Bool
    private(set) var nextPage: Page?
   
    var error: AppError?

    init(usersFetchInteractor: UsersFetchUseCase) {
        self.usersFetchInteractor = usersFetchInteractor
        self.users = []
        self.isLoading = false
        self.error = nil
    }
    
    @Sendable func fetchFirstPage() async {
        guard !isLoading else { return }
        
        isLoading = true

        Task.detached {
            do {
                let response = try await self.usersFetchInteractor.fetch()
                await MainActor.run {
                    self.users = response.users
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
                let response = try await self.usersFetchInteractor.fetch(with: nextPage)
                await MainActor.run {
                    self.users.append(contentsOf: response.users)
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
}
