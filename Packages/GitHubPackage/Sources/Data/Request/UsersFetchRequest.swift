import Entity

package struct UsersFetchRequest {
    let page: Page?

    package init(page: Page?) {
        self.page = page
    }
}

extension UsersFetchRequest: APIRequest {
    package typealias Response = [UserResponse]

    package var method: HTTPMethod { .get }
    package var path: String { "/users" }
    package var nextPage: Page? { page }
}
