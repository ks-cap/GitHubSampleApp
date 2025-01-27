import Foundation

package struct BuildConfig: Sendable {
    package let baseURL: @Sendable () -> URL
}

package extension BuildConfig {
    static let live: BuildConfig = Self(
        baseURL: { .init(string: Bundle.main.baseURLString)! }
    )
}

private extension Bundle {
    var baseURLString: String { object(forInfoDictionaryKey: "GitHubBaseURL") as! String }
}
