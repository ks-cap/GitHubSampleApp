struct User: Identifiable, Decodable, Hashable {
    let id: Int
    let login: String
    let reposUrl: String
    let avatarUrl: String
}
