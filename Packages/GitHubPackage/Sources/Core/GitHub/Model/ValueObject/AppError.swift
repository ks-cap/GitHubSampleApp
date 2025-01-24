import Foundation

package enum AppError: LocalizedError {
    case invalidUrl
    case responseType
    case decode
    case badRequest
    case forbidden
    case notFound
    case server
    case unknown

    package var failureReason: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .responseType:
            return "Invalid Response Type"
        case .badRequest:
            return "Bad Request"
        case .decode:
            return "Decode Error"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .server:
            return "Server Error"
        case .unknown:
            return "Unknwon Error"
        }
    }
}
