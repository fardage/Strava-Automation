import Domain
import Foundation
import Vapor

// MARK: - HubRequest

struct HubRequest: Content {
    enum CodingKeys: String, CodingKey {
        case hubModeRequest = "hub.mode"
        case verifyToken = "hub.verify_token"
        case challenge = "hub.challenge"
    }

    let hubModeRequest: HubModeRequest
    let verifyToken: String
    let challenge: String

    var hub: Hub {
        Hub(
            mode: hubModeRequest.mode,
            verifyToken: verifyToken,
            challenge: challenge
        )
    }
}

enum HubModeRequest: String, Codable {
    case subscribe

    var mode: Hub.Mode {
        switch self {
        case .subscribe:
            .subscribe
        }
    }
}

// MARK: - HubResponse

struct HubResponse: Content {
    let challenge: String

    enum CodingKeys: String, CodingKey {
        case challenge = "hub.challenge"
    }
}

extension CallbackValidation {
    var hubResponse: HubResponse {
        HubResponse(challenge: challenge)
    }
}
