import SafariServices
import SwiftUI

package struct SafariView {
    package let url: URL
    
    package init(url: URL) {
        self.url = url
    }
}

// MARK: - UIViewControllerRepresentable

extension SafariView: UIViewControllerRepresentable {
    package func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController: SFSafariViewController
        safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }

    package func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
