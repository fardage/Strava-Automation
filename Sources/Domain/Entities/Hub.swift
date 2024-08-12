import Foundation

public struct Hub {
    public enum Mode: String {
        case subscribe
    }

    public let mode: Mode
    public let verifyToken: String
    public let challenge: String

    public init(mode: Mode, verifyToken: String, challenge: String) {
        self.mode = mode
        self.verifyToken = verifyToken
        self.challenge = challenge
    }
}

public struct CallbackValidation {
    public let challenge: String

    public init(challenge: String) {
        self.challenge = challenge
    }
}
