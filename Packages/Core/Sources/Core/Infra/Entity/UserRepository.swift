struct UserRepository: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let htmlUrl: String
    let fork: Bool
    let language: String?
    let watchersCount: Int?
    let description: String?
}
