import Foundation
import GitHubCore

@MainActor
@Observable
final class UserRepositoryScreenStore {
    private let userReposRepository: UserReposRepository
    
    private(set) var user: User
    private(set) var nextPage: Page?
    private(set) var repositories: [UserRepository]
    private(set) var isLoading: Bool
    private(set) var selectUrl: URL?
    private(set) var error: AppError?

    init(
        userReposRepository: UserReposRepository,
        user: User
    ) {
        self.userReposRepository = userReposRepository
        self.user = user
        self.repositories = []
        self.isLoading = false
        self.selectUrl = nil
        self.error = nil
    }
    
    @Sendable func fetchFirstPage() async {
        guard !isLoading else { return }
        
        isLoading = true

        do {
            let response = try await userReposRepository.fetch(username: user.login, nextPage: nextPage)
            
            isLoading = false
            repositories = response.repositories
            nextPage = response.nextPage
        } catch {
            isLoading = false

            if let error = error as? AppError {
                self.error = error
            }
        }
    }
    
    @Sendable func fetchNextPage() async {
        guard !isLoading, let nextPage else { return }
        
        isLoading = true

        do {
            let response = try await userReposRepository.fetch(username: user.login, nextPage: nextPage)
            
            isLoading = false
            repositories.append(contentsOf: response.repositories)
            self.nextPage = response.nextPage
        } catch {
            isLoading = false
            
            if let error = error as? AppError {
                self.error = error
            }
        }
    }
    
    func selectRepository(_ repository: UserRepository) {
        do {
            let url = try repository.url
            self.selectUrl = url
        } catch {
            if let error = error as? AppError {
                self.error = error
            }
        }
    }
    
    func onErrorAlertDismiss() {
        error = nil
    }
    
    func onSafariDismiss() {
        selectUrl = nil
    }
}
