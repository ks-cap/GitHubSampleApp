import Foundation

struct UsersFetchRequest: GithubRequest {
    typealias Response = [User]

    let page: Page?

    var method: HTTPMethod { .get }
    var path: String { "/users" }
    var nextPage: Page? { page }
}
