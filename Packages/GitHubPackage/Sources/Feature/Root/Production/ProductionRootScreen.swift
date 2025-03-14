import Factory
import SwiftUI

public struct ProductionRootScreen: View {
    private enum TabSelecion: Hashable {
        case users
        case settings
    }
   
    @State private var currentTab: TabSelecion

    public init() {
        currentTab = .users
    }

    public var body: some View {
        TabView(selection: $currentTab) {
            Tab("Users", systemImage: "list.bullet", value: .users) {
                ScreenFactory.createUserListScreen()
            }
            
            Tab("Settings", systemImage: "gearshape", value: .settings) {
                ScreenFactory.createSettingsScreen()
            }
        }
    }
}
