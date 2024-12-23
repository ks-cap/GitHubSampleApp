import Foundation

protocol APIClient: Sendable {
    func perform<Request: GithubRequest>(request: Request, nextPage: Page?) async throws -> (response: Request.Response, nextPage: Page?)
}

final class APIClientLive {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension APIClientLive: APIClient {
    func perform<Request: GithubRequest>(request: Request, nextPage: Page?) async throws -> (response: Request.Response, nextPage: Page?) {
        let urlRequest = request.build(nextPage: nextPage)
        let (data, response) = try await session.data(for: urlRequest)
        return try request.response(from: data, urlResponse: response)
    }
}
