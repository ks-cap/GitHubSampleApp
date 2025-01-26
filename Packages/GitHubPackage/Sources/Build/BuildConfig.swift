import Foundation
import SwiftUI

package struct BuildConfig: Sendable {
    public var baseURL: @Sendable () -> URL
}

extension BuildConfig {
    package static let live: BuildConfig = {
        let urlString = Bundle.main.infoDictionary!["GitHubBaseURL"] as! String
        return Self(baseURL: { URL(string: urlString)! })
    }()
}
