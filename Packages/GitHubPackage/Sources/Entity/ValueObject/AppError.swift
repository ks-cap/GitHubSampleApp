import Foundation

package enum AppError: LocalizedError {
    case invalidUrl
    case responseType
    case decode
    case client
    case server
    case unknown

    package var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .responseType:
            return "Invalid Response Type"
        case .decode:
            return "Decode Error"
        case .client:
            return "Client Error"
        case .server:
            return "Server Error"
        case .unknown:
            return "Unknwon Error"
        }
    }
}
