import Foundation

struct UserRepository: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let htmlUrl: String
    let fork: Bool
    let language: String?
    let watchersCount: Int?
    let description: String?
    
    var url: URL {
        get throws {
            try htmlUrl.asURL
        }
    }
}

extension String {
    var asURL: URL {
        get throws {
            guard let url = URL(string: self) else {
                throw AppErrorType.invalidUrl
            }
            return url
        }
    }
}
