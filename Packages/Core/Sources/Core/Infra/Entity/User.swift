struct User: Identifiable, Decodable, Hashable, Sendable {
    let id: Int
    let login: String
    let reposUrl: String
    let avatarUrl: String
}
