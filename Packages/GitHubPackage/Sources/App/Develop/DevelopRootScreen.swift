import DebugFeature
import SettingsFeature
import SwiftUI
import UsersFeature

public struct DevelopRootScreen: View {
    private enum TabSelecion: Hashable {
        case users
        case settings
        case debug
    }
   
    @State private var currentTab: TabSelecion

    public init() {
        currentTab = .users
    }

    public var body: some View {
        TabView(selection: $currentTab) {
            Tab("Users", systemImage: "list.bullet", value: .users) {
                UserListScreen(store: .init())
            }
            
            Tab("Settings", systemImage: "gearshape", value: .settings) {
                SettingsScreen(store: .init())
            }
            
            Tab("Debug", systemImage: "ladybug", value: .debug) {
                DebugScreen()
            }
        }
    }
}
