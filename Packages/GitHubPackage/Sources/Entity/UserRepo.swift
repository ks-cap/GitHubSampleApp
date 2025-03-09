import Foundation

package struct UserRepo: Identifiable, Decodable, Hashable, Sendable {
    package let id: Int
    package let name: String
    package let htmlUrl: String
    package let fork: Bool
    package let language: String?
    package let watchersCount: Int?
    package let description: String?
    
    package var url: URL {
        get throws {
            guard let url = URL(string: htmlUrl) else {
                throw AppError.invalidUrl
            }
            return url
        }
    }
    
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
