import SwiftUI

public enum Window {
    @MainActor
    public static func build() -> some View {
        UsersBuilder.build()
    }
}
