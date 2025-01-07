import Foundation

protocol APIClient: Sendable {
    func perform<Request: GithubRequest>(request: Request) async throws -> (response: Request.Response, nextPage: Page?)
}

final class APIClientLive {
    private let session: URLSession
    private let accessTokenStore: AccessTokenStore
    
    init(
        session: URLSession = .shared,
        accessTokenStore: AccessTokenStore = .shared
    ) {
        self.session = session
        self.accessTokenStore = accessTokenStore
    }
}

extension APIClientLive: APIClient {
    func perform<Request: GithubRequest>(request: Request) async throws -> (response: Request.Response, nextPage: Page?) {
        let accessToken = await accessTokenStore.get()
        let urlRequest = request.build(accessToken: accessToken)
        let (data, response) = try await session.data(for: urlRequest)
        return try request.response(from: data, urlResponse: response)
    }
}
