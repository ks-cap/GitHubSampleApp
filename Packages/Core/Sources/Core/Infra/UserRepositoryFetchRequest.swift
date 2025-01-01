import Foundation

struct UserRepositoryFetchRequest: GithubRequest {
    typealias Response = [UserRepository]

    let username: String

    var method: HTTPMethod { .get }
    var path: String { "/users/\(username)/repos" }
}
