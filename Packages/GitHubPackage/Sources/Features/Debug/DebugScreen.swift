import PulseUI
import SwiftUI

package struct DebugScreen: View {
    package init() {}
    
    package var body: some View {
        NavigationStack {
            Section {
                ConsoleView()
            }
        }
    }
}

#Preview {
    DebugScreen()
}
