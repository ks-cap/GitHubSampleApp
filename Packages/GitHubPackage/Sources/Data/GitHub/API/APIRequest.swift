import Foundation

package enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

package protocol APIRequest {
    associatedtype Response: Decodable
    
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var nextPage: Page? { get }
}

extension APIRequest {
    package var baseUrl: URL { .init(string: "https://api.github.com")! }

    package func build(accessToken: String?) -> URLRequest {
        let url = nextPage?.url ?? baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        request.timeoutInterval = .init(60)

        if let accessToken = accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    package func response(
        from data: Data,
        with httpUrlResponse: HTTPURLResponse
    ) throws -> (response: Response, nextPage: Page?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        switch httpUrlResponse.statusCode {
        case 200..<300:
            do {
                let decoded = try decoder.decode(Response.self, from: data)
                
                var nextPage: Page?
                if let link = httpUrlResponse.value(forHTTPHeaderField: "Link") {
                    nextPage = .init(nextInLinkHeader: link)
                }
                
                return (response: decoded, nextPage: nextPage)
            } catch {
                throw AppErrorType.decode
            }

        case 400:
            throw AppErrorType.badRequest

        case 403:
            throw AppErrorType.forbidden
            
        case 404:
            throw AppErrorType.notFound

        default:
            throw AppErrorType.unknown
        }
    }
}
