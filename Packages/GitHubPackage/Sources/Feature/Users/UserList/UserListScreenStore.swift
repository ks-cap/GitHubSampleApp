import Data
import Domain
import Entity
import Foundation
import UICore

@MainActor
@Observable
package final class UserListScreenStore {
    private let usersRepository: UsersRepository

    private(set) var viewState: LoadingState<[User]>
    private(set) var nextPage: Page?
    private(set) var error: Error?

    package init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
        self.viewState = .idle
        self.error = nil
    }
    
    @Sendable func fetchFirstPage() async {
        guard viewState != .loading else { return }

        viewState = .loading

        do {
            let response = try await usersRepository.fetch()
            
            viewState = .success(response.users)
            nextPage = response.nextPage
        } catch {
            viewState = .failure
            self.error = error
        }
    }
    
    @Sendable func fetchNextPage() async {
        guard case .success(let loaded) = viewState, let nextPage else { return }

        do {
            let response = try await usersRepository.fetch(with: nextPage)
            let newUsers = loaded + response.users
            
            viewState = .success(newUsers)
            self.nextPage = response.nextPage
        } catch {
            self.error = error
        }
    }
    
    @Sendable func refresh() async {
        guard viewState != .loading else { return }

        do {
            let response = try await usersRepository.fetch()
            
            viewState = .success(response.users)
            nextPage = response.nextPage
        } catch {
            self.error = error
        }
    }
    
    func onErrorAlertDismiss() {
        error = nil
    }
}
