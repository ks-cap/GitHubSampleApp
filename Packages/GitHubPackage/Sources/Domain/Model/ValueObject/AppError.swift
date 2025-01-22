import Foundation

package struct AppError: Identifiable {
    package let id = UUID()
    package let error: Error

    package init(error: Error) {
        guard let error = error as? AppErrorType else { fatalError() }
        self.error = error
    }
}

package enum AppErrorType: LocalizedError {
    case invalidUrl
    case responseType
    case decode
    case badRequest
    case forbidden
    case notFound
    case unknown

    package var errorDescription: String? {
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
        case .unknown:
            return "Unknwon Error"
        }
    }
}
