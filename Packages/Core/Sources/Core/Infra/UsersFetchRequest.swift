import Foundation

struct UsersFetchRequest: GithubRequest {
    typealias Response = [User]

    var method: HTTPMethod { .get }
    var path: String { "/users" }
}
