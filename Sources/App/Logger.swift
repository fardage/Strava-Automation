import Domain
import Foundation
import Vapor

public struct TraceLogger: Domain.Logger {
    private let vaporLogger: Vapor.Logger

    public init(vaporLogger: Vapor.Logger) {
        self.vaporLogger = vaporLogger
    }

    public func debug(_ message: String) {
        vaporLogger.debug(Logger.Message(stringLiteral: message))
    }

    public func info(_ message: String) {
        vaporLogger.info(Logger.Message(stringLiteral: message))
    }

    public func error(_ message: String) {
        vaporLogger.error(Logger.Message(stringLiteral: message))
    }
}
