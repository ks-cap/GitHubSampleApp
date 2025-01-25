import SwiftUI

package enum LoadingState<V: Equatable>: Equatable {
    case idle
    case loading
    case success(V)
    case failure
}

extension LoadingState {
    package var value: V? {
        guard case .success(let value) = self else {
            return nil
        }
        return value
    }
}

package struct AsyncContentView<V: Equatable, Success: View>: View {
    private let state: LoadingState<V>
    private let success: (V) -> Success
    private let onRetryTap: (() -> Void)?
    
    package init(
        state: LoadingState<V>,
        @ViewBuilder success: @escaping (V) -> Success,
        onRetryTap: (() -> Void)? = nil
    ) {
        self.state = state
        self.success = success
        self.onRetryTap = onRetryTap
    }
    
    package var body: some View {
        switch state {
        case .idle:
            EmptyView()

        case .loading:
            ProgressView()
            
        case let .success(data):
            success(data)
            
        case .failure:
            FailureView(onRetryTap: onRetryTap)
                .padding()
        }
    }
}

private struct FailureView: View {
    let onRetryTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "cloud.rain")
                .font(.system(size: 120))
            
            Text("Please try again.")
            
            if let onRetryTap {
                Button(action: onRetryTap) {
                    Label(
                        title: { Text("Retry") },
                        icon: { Image(systemName: "arrow.counterclockwise") }
                    )
                }
                .fontWeight(.medium)
            }
        }
    }
}
