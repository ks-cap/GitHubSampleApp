struct User: Identifiable, Decodable {
    let id: Int
    let login: String
    let reposUrl: String
    let avatarUrl: String
}
