import OSLog

package enum Logger {
    package static let standard: os.Logger = .init(
        subsystem: Bundle.main.bundleIdentifier!,
        category: LogCategory.standard.rawValue
    )
}

// MARK: - Private

private enum LogCategory: String {
    case standard = "Standard"
}
