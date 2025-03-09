import Entity

package struct UserResponse: Decodable {
    package let id: Int
    package let login: String
    package let reposUrl: String
    package let avatarUrl: String
    
    package init(id: Int, login: String, reposUrl: String, avatarUrl: String) {
        self.id = id
        self.login = login
        self.reposUrl = reposUrl
        self.avatarUrl = avatarUrl
    }
}

extension UserResponse {
    func toEntity() -> User {
        .init(
            id: id,
            login: login,
            reposUrl: reposUrl,
            avatarUrl: avatarUrl
        )
    }
}
