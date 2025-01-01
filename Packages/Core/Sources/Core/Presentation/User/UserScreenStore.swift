import Foundation

@MainActor
final class UserScreenStore: ObservableObject {
    private let userRepositoryFetchInteractor: UserRepositoryFetchUseCase
    
    private(set) var user: User
    private(set) var nextPage: Page?

    @Published private(set) var repositories: [UserRepository]
    @Published private(set) var isLoading: Bool
    @Published private(set) var url: URL?
    @Published var isSafariPresented: Bool

    init(user: User, userRepositoryFetchInteractor: UserRepositoryFetchUseCase) {
        self.userRepositoryFetchInteractor = userRepositoryFetchInteractor
        self.user = user
        self.repositories = []
        self.isLoading = false
        self.url = nil
        self.isSafariPresented = false
    }
    
    @Sendable func onAppear() async {
        guard !isLoading else { return }
        
        isLoading = true

        Task.detached {
            let response = try await self.userRepositoryFetchInteractor.fetch(
                username: self.user.login,
                nextPage: self.nextPage
            )
            await MainActor.run {
                self.repositories = response.repositories
                self.nextPage = response.nextPage
                self.isLoading = false
            }
        }
    }
    
    @Sendable func onReach() async {
        guard !isLoading, let nextPage else { return }
        
        isLoading = true

        Task.detached {
            let response = try await self.userRepositoryFetchInteractor.fetch(
                username: self.user.login,
                nextPage: nextPage
            )
            await MainActor.run {
                
                self.repositories.append(contentsOf: response.repositories)
                self.nextPage = response.nextPage
                self.isLoading = false
            }
        }
    }
    
    func onOpen(_ htmlUrl: String) {
        url = URL(string: htmlUrl)
        isSafariPresented = true
    }
}
