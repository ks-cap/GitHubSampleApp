import Foundation
import KeychainAccessCore
import LogCore
import Model

package protocol APIClient: Sendable {
    func perform<Request: APIRequest>(request: Request) async throws -> (response: Request.Response, nextPage: Page?)
}

package final class APIClientLive {
    private let session: URLSession
    private let accessTokenClient: AccessTokenClient
    
    package init(
        session: URLSession = .shared,
        accessTokenClient: AccessTokenClient = AccessTokenClientLive.shared
    ) {
        self.session = session
        self.accessTokenClient = accessTokenClient
    }
}

// MARK: - APIClientLive

extension APIClientLive: APIClient {
    package func perform<Request: APIRequest>(request: Request) async throws -> (response: Request.Response, nextPage: Page?) {
        let accessToken = await accessTokenClient.get()
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

extension APIClientLive {
    func logTracker(request: URLRequest, httpUrlResponse: HTTPURLResponse, data: Data) {
        Logger.standard.debug("""
        🏁🏁🏁🏁🏁 [\(String(httpUrlResponse.statusCode))] \(request.httpMethod ?? "") \(request.debugDescription)
        Headers: \(httpUrlResponse.allHeaderFields.map { "\($0): \($1)" })
        Body: \(String(data: data, encoding: .utf8) ?? "")
        """)
    }
}
