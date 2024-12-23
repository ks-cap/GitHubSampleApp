import Foundation

@MainActor
final class UsersScreenStore: ObservableObject {
    private let usersFetchInteractor: UsersFetchUseCase

    @Published private(set) var users: [User]
    @Published private(set) var isLoading: Bool
    
    private(set) var nextPage: Page?

    init(usersFetchInteractor: UsersFetchUseCase) {
        self.usersFetchInteractor = usersFetchInteractor
        self.users = []
        self.isLoading = false
    }
    
    @Sendable func onAppear() async {
        guard !isLoading else { return }
        
        isLoading = true

        Task.detached {
            let response = try await self.usersFetchInteractor.fetch()
            await MainActor.run {
                self.users = response.users
                self.nextPage = response.nextPage
                self.isLoading = false
            }
        }
    }
    
    @Sendable func onReach() async {
        guard !isLoading, let nextPage else { return }
        
        isLoading = true

        Task.detached {
            let response = try await self.usersFetchInteractor.fetch(with: nextPage)
            await MainActor.run {
                self.users.append(contentsOf: response.users)
                self.nextPage = response.nextPage
                self.isLoading = false
            }
        }
    }

    @Sendable func onRefresh() async {
        isLoading = true

        Task.detached {
            let response = try await self.usersFetchInteractor.fetch()
            await MainActor.run {
                self.users = response.users
                self.nextPage = response.nextPage
                self.isLoading = false
            }
        }
    }
}
