import Foundation

struct UserRepositoryFetchRequest: GithubRequest {
    typealias Response = [UserRepository]

    let username: String
    let page: Page?

    var method: HTTPMethod { .get }
    var path: String { "/users/\(username)/repos" }
    var nextPage: Page? { page }
}
