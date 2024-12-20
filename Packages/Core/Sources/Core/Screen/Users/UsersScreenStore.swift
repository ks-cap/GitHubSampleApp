import Foundation

@MainActor
final class UsersScreenStore: ObservableObject {
    private let usersFetchInteractor: UsersFetchUseCase

    @Published private(set) var users: [User]
    @Published private(set) var isLoading: Bool
    
    init(usersFetchInteractor: UsersFetchUseCase) {
        self.usersFetchInteractor = usersFetchInteractor
        self.users = []
        self.isLoading = false
    }
    
    @Sendable func onAppear() async {
        guard !isLoading else { return }
        
        isLoading = true

        Task.detached {
            let users = try await self.usersFetchInteractor.fetch()
            await MainActor.run {
                self.users = users
                self.isLoading = false
            }
        }
    }
    
    @Sendable func onRefresh() async {        
        isLoading = true

        Task.detached {
            let users = try await self.usersFetchInteractor.fetch()
            await MainActor.run {
                self.users = users
                self.isLoading = false
            }
        }
    }
}
