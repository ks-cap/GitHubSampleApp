import Foundation

@MainActor
final class UserScreenStore: ObservableObject {
    let user: User

    init(user: User) {
        self.user = user
    }
}
