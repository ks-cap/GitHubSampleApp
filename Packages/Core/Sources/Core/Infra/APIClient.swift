import Foundation

protocol APIClient: Sendable {
    func send<R: GithubRequest>(request: R) async throws -> R.Response
}

final class APIClientLive {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension APIClientLive: APIClient {
    func send<R: GithubRequest>(request: R) async throws -> R.Response {
        let urlRequest = request.build()
        let (data, urlResponse) = try await session.data(for: urlRequest)
        let response = try request.response(from: data, urlResponse: urlResponse)
        return response
    }
}
