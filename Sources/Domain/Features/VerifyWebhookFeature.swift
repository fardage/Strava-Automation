import Foundation

public struct VerifyWebhookFeature: Sendable {
    enum VerifyError: Error {
        case wrongModeOrVerifyToken
    }

    private let configuration: Configuration
    private let logger: Logger

    public init(configuration: Configuration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
    }

    public func execute(hub: Hub) -> Result<CallbackValidation, Error> {
        let isSubscribe = hub.mode == .subscribe
        let isValidToken = hub.verifyToken == configuration.verifyToken

        if isSubscribe && isValidToken {
            let validation = CallbackValidation(challenge: hub.challenge)
            return .success(validation)
        } else {
            logger.error("Invalid mode or verify token received")
            return .failure(Self.VerifyError.wrongModeOrVerifyToken)
        }
    }
}
