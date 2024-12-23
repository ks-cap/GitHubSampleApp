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
}

extension GithubRequest {
    var baseUrl: URL { .init(string: "https://api.github.com")! }

    func build(nextPage: Page?) -> URLRequest {
        let url = nextPage?.url ?? baseUrl.appendingPathComponent(path)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        var request = URLRequest(url: url)
        request.url = components?.url
        request.httpMethod = method.rawValue
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(GithubAccessToken.shared.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        return request
    }

    func response(from data: Data, urlResponse: URLResponse) throws -> (response: Response, nextPage: Page?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
            throw NSError()
        }
    
        switch statusCode {
        case 200..<300:
            let response = try decoder.decode(Response.self, from: data)
            
            var nextPage: Page?
            if let urlResponse = urlResponse as? HTTPURLResponse, let link = urlResponse.value(forHTTPHeaderField: "Link") {
                nextPage = Page(nextInLinkHeader: link)
            }
            
            return (response: response, nextPage: nextPage)

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
