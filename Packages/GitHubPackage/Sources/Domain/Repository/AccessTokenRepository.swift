package protocol AccessTokenRepository: Sendable {
    func fetch() async throws -> String?
    func update(token: String) async throws
}
