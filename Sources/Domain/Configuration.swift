import Foundation

public protocol Configuration: Sendable {
    var maxCommuteDistanceInMeter: Float { get }
    var verifyToken: String { get }
}
