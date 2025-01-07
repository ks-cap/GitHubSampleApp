import Foundation

struct AppError: Identifiable {
    let id = UUID()
    let error: Error

    init(error: Error) {
        guard let error = error as? AppErrorType else { fatalError() }
        self.error = error
    }
}

enum AppErrorType: LocalizedError {
    case invalidUrl
    case invalidResponseType
    case decode
    case badRequest
    case forbidden
    case notFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalidResponseType:
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
