import SwiftUI

extension View {
    package func errorAlert(
        error: (some LocalizedError)?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            isPresented: .init(
                get: { error != nil },
                set: { _ in onDismiss() }
            ),
            error: error,
            actions: { _ in },
            message: { error in
                Text(error.failureReason ?? "")
            }
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
