import LogdogUI
import SwiftUI

package struct DebugScreen: View {
    package init() {}
    
    package var body: some View {
        NavigationStack {
            Section {
                LogdogScreen()
                    .navigationTitle("Log")
            }
        }
    }
}

#Preview {
    DebugScreen()
}
