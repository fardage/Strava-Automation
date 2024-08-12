import Foundation

public protocol Logger: Sendable {
    func debug(_ message: String)
    func info(_ message: String)
    func error(_ message: String)
}
