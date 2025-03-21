import Entity

package struct UserRepoResponse: Decodable {
    package let id: Int
    package let name: String
    package let htmlUrl: String
    package let fork: Bool
    package let language: String?
    package let watchersCount: Int?
    package let description: String?
    
    package init(id: Int, name: String, htmlUrl: String, fork: Bool, language: String?, watchersCount: Int?, description: String?) {
        self.id = id
        self.name = name
        self.htmlUrl = htmlUrl
        self.fork = fork
        self.language = language
        self.watchersCount = watchersCount
        self.description = description
    }
}

extension UserRepoResponse {
    func toEntity() -> UserRepo {
        .init(
            id: id,
            name: name,
            htmlUrl: htmlUrl,
            fork: fork,
            language: language,
            watchersCount: watchersCount,
            description: description
        )
    }
}
