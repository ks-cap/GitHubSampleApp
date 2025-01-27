import SwiftUI

package extension View {
    func errorAlert(
        error: Error?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            "Error",
            isPresented: .init(
                get: { error != nil },
                set: { _ in onDismiss() }
            ),
            actions: {},
            message: { Text(error?.localizedDescription ?? "") }
        )
    }

    func safariFullScreenCover(
        url: URL?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        fullScreenCover(
            isPresented: .init(
                get: { url != nil },
                set: { _ in onDismiss() }
            ),
            content: { 
                if let url {
                    SafariView(url: url)
                }
            }
        )
    }
}
