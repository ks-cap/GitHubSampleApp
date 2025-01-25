import GitHubCore
import UsersFeature
import SettingsFeature
import SwiftUI

public enum Window {
    @MainActor
    public static func build() -> some View {
        UserListBuilder.build()
    }
}

private enum TabSelecion: Hashable {
    case users
    case settings
    
    var title: String {
        switch self {
        case .users:
            return "Users"
        case .settings:
            return "Settings"
        }
    }
}

public struct ProductionRootScreen: View {
    @State private var currentTab: TabSelecion = .users

    public init() {}

    public var body: some View {
        TabView(selection: $currentTab) {
            Tab("Users", systemImage: "list.bullet", value: .users) {
                UserListScreen(store: .init(usersRepository: UsersDefaultRepository()))
            }
            
            Tab("Settings", systemImage: "list.bullet", value: .settings) {
                SettingsScreen(store: .init(accessTokenRepository: AccessTokenDefaultRepository()))
            }
        }
    }
}
