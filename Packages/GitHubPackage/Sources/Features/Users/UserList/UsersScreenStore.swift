import Foundation
import GitHubCore

@MainActor
@Observable
final class UsersScreenStore {
    private let usersRepository: UsersRepository

    private(set) var users: [User]
    private(set) var isLoading: Bool
    private(set) var nextPage: Page?
   
    var error: AppError?
    var isSetPresented: Bool

    init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
        self.users = []
        self.isLoading = false
        self.error = nil
        self.isSetPresented = false
    }
    
    @Sendable func fetchFirstPage() async {
        guard !isLoading else { return }
        
        isLoading = true

        do {
            let response = try await usersRepository.fetch()
            
            isLoading = false
            users = response.users
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
            let response = try await usersRepository.fetch(with: nextPage)

            isLoading = false
            users.append(contentsOf: response.users)
            self.nextPage = response.nextPage
        } catch {
            isLoading = false
            self.error = AppError(error: error)
        }
    }
    
    func onSettingsTapped() {
        isSetPresented = true
    }
}
