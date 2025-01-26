import Foundation

package struct BuildConfig: Sendable {
    package var baseURL: @Sendable () -> URL
}

extension BuildConfig {
    package static let live: BuildConfig = {
        let urlString = Bundle.main.infoDictionary!["GitHubBaseURL"] as! String
        return Self(baseURL: { URL(string: urlString)! })
    }()
}
