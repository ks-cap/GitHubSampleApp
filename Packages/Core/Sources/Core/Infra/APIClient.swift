import Foundation

/// @mockable
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
        let (data, urlResponse) = try await session.data(for: urlRequest)
        
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            throw AppErrorType.responseType
        }

#if DEBUG
        logTracker(request: urlRequest, httpUrlResponse: httpUrlResponse, data: data)
#endif

        return try request.response(from: data, with: httpUrlResponse)
    }
}

private extension APIClientLive {
    func logTracker(request: URLRequest, httpUrlResponse: HTTPURLResponse, data: Data) {
        logger.debug("""
        🏁🏁🏁🏁🏁 [\(String(httpUrlResponse.statusCode))] \(request.httpMethod ?? "") \(request.debugDescription)
        Headers: \(httpUrlResponse.allHeaderFields.map { "\($0): \($1)" })
        Body: \(String(data: data, encoding: .utf8) ?? "")
        """)
    }
}
