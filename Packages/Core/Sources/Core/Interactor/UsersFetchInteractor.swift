protocol UsersFetchUseCase: Sendable {
    func fetch() async throws -> [User]
}

final class UsersFetchInteractor: UsersFetchUseCase {
    private let client: APIClient
    
    init(client: APIClient = APIClientLive()) {
        self.client = client
    }

    func fetch() async throws -> [User] {
        let request = UsersFetchRequest()
        return try await client.send(request: request)
    }
}
