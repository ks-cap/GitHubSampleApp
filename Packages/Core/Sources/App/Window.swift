import SwiftUI
import UsersFeature

public enum Window {
    @MainActor
    public static func build() -> some View {
        UserListBuilder.build()
    }
}
