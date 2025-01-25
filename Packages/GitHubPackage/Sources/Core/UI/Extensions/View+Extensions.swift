import SwiftUI

extension View {
    package func errorAlert(
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
}

extension View {
    package func safariFullScreenCover(
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
