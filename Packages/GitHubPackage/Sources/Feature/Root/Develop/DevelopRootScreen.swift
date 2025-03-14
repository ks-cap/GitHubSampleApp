import Factory
import Pulse
import PulseProxy
import SwiftUI

public struct DevelopRootScreen: View {
    private enum TabSelecion: Hashable {
        case users
        case settings
        case debug
    }

    @State private var currentTab: TabSelecion

    public init() {
        currentTab = .users
        NetworkLogger.enableProxy()
    }

    public var body: some View {
        TabView(selection: $currentTab) {
            Tab("Users", systemImage: "list.bullet", value: .users) {
                ScreenFactory.createUserListScreen()
            }
            
            Tab("Settings", systemImage: "gearshape", value: .settings) {
                ScreenFactory.createSettingsScreen()
            }
            
            Tab("Debug", systemImage: "ladybug", value: .debug) {
                ScreenFactory.createDebugScreen()
            }
        }
    }
}
