import Model

package struct UserRepositoryFetchRequest {
    let username: String
    let page: Page?

    package init(username: String, page: Page?) {
        self.username = username
        self.page = page
    }
}

extension UserRepositoryFetchRequest: APIRequest {
    package typealias Response = [UserRepository]

    package var method: HTTPMethod { .get }
    package var path: String { "/users/\(username)/repos" }
    package var nextPage: Page? { page }
}
