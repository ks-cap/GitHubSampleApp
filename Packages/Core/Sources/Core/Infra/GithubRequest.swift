import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol GithubRequest {
    associatedtype Response: Decodable
    
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension GithubRequest {
    var baseUrl: URL { .init(string: "https://api.github.com")! }
    var queryItems: [URLQueryItem] { [] }

    func build() -> URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        var request = URLRequest(url: url)
        request.url = components?.url
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(GithubAccessToken.shared.accessToken)", forHTTPHeaderField: "Authorization")

        return request
    }

    func response(from data: Data, urlResponse: URLResponse) throws -> Response {
        let jsonDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
            throw NSError()
        }
        
        switch statusCode {
        case 200..<300:
            return try jsonDecoder.decode(Response.self, from: data)
        default:
            throw NSError()
        }
    }
}

final class GithubAccessToken {
    nonisolated(unsafe) static let shared = GithubAccessToken()

    let accessToken: String

    private init() {
        guard let path = Bundle.main.path(forResource: "GithubAccessToken", ofType: "txt"),
              let token = try? String(contentsOfFile: path, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines),
              !token.isEmpty
        else {
            fatalError("Need Github Access Token")
        }
        
        accessToken = token
    }
}
