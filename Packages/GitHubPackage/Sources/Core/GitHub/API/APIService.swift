import Build
import Foundation
import KeychainAccessCore
import LogCore

/// @mockable
package protocol APIService: Sendable {
    func perform<Request: APIRequest>(request: Request) async throws -> (response: Request.Response, nextPage: Page?)
}

// MARK: - APIDefaultService

package final class APIDefaultService {
    private let session: URLSession
    private let buildConfig: BuildConfig
    private let keychainAccessClient: KeychainAccessClient

    package init(
        session: URLSession = .shared,
        buildConfig: BuildConfig = .live,
        keychainAccessClient: KeychainAccessClient = KeychainAccessDefaultClient.shared
    ) {
        self.session = session
        self.buildConfig = buildConfig
        self.keychainAccessClient = keychainAccessClient
    }
}

extension APIDefaultService: APIService {
    package func perform<Request: APIRequest>(request: Request) async throws -> (response: Request.Response, nextPage: Page?) {
        let accessToken = try await keychainAccessClient.get()
        let urlRequest = request.build(buildConfig, accessToken: accessToken)
        let (data, urlResponse) = try await session.data(for: urlRequest)
        
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            throw AppError.responseType
        }

#if DEBUG
        logTracker(request: urlRequest, httpUrlResponse: httpUrlResponse, data: data)
#endif

        return try request.response(from: data, with: httpUrlResponse)
    }
}

private extension APIDefaultService {
    func logTracker(request: URLRequest, httpUrlResponse: HTTPURLResponse, data: Data) {
        Logger.standard.debug("""
        🏁🏁🏁🏁🏁 [\(String(httpUrlResponse.statusCode))] \(request.httpMethod ?? "") \(request.debugDescription)
        Headers: \(httpUrlResponse.allHeaderFields.map { "\($0): \($1)" })
        Body: \(String(data: data, encoding: .utf8) ?? "")
        """)
    }
}
