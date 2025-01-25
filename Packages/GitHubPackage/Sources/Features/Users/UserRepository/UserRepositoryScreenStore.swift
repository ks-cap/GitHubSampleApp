import Foundation
import GitHubCore
import UICore

@MainActor
@Observable
final class UserRepositoryScreenStore {
    private let userReposRepository: UserReposRepository
    
    private(set) var user: User
    private(set) var nextPage: Page?
    private(set) var viewState: LoadingState<[UserRepository]>
    private(set) var selectUrl: URL?
    private(set) var error: Error?

    init(
        userReposRepository: UserReposRepository,
        user: User
    ) {
        self.userReposRepository = userReposRepository
        self.user = user
        self.viewState = .idle
    }
    
    @Sendable func fetchFirstPage() async {
        guard viewState != .loading else { return }

        viewState = .loading

        do {
            let response = try await userReposRepository.fetch(username: user.login)
            
            viewState = .success(response.repositories)
            nextPage = response.nextPage
        } catch {
            viewState = .failure
            self.error = error
        }
    }
    
    @Sendable func fetchNextPage() async {
        guard case .success(let loaded) = viewState, let nextPage else { return }

        do {
            let response = try await userReposRepository.fetch(username: user.login, nextPage: nextPage)
            let newRepositories = loaded + response.repositories

            viewState = .success(newRepositories)
            self.nextPage = response.nextPage
        } catch {
            self.error = error
        }
    }
    
    @Sendable func refresh() async {
        guard viewState != .loading else { return }

        do {
            let response = try await userReposRepository.fetch(username: user.login)
            
            viewState = .success(response.repositories)
            nextPage = response.nextPage
        } catch {
            self.error = error
        }
    }

    func selectRepository(_ repository: UserRepository) {
        do {
            let url = try repository.url
            self.selectUrl = url
        } catch {
            self.error = error
        }
    }
    
    func onErrorAlertDismiss() {
        error = nil
    }
    
    func onSafariDismiss() {
        selectUrl = nil
    }
}
