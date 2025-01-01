import Foundation

struct AppError: Identifiable {
    let id = UUID()
    let error: AppErrorType

    init(error: AppErrorType) {
        self.error = error
    }
}

enum AppErrorType: LocalizedError {
    case decode
    case badRequest
    case forbidden
    case notFound
    case unknown

    var errorDescription: String? {
        switch self {
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
