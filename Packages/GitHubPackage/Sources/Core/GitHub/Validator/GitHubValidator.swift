import Foundation

package protocol GitHubValidator {
    func validate(accessToken: String) -> Bool
}

package struct GitHubDefaultValidator {
    package init() {}
}

extension GitHubDefaultValidator: GitHubValidator {
    package func validate(accessToken: String) -> Bool {
        !accessToken.isEmpty
    }
}
