import Domain
import Foundation
import Vapor

// MARK: - CodenRequest

struct CodenRequest: Content {
    let clientID: String
    let clientSecret: String
    let code: String
    let grantType: String

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case code
        case grantType = "grant_type"
    }
}

// MARK: - AccessToken

struct AccessToken: Content {
    let tokenType: String
    let expiresAt: Int
    let expiresIn: Int
    let refreshToken: String
    let accessToken: String
    let athlete: Athlete

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresAt = "expires_at"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case athlete
    }

    var domainAccessToken: Domain.AccessToken {
        Domain.AccessToken(
            tokenType: tokenType,
            expiresAt: Date(timeIntervalSince1970: TimeInterval(expiresAt)),
            refreshToken: refreshToken,
            accessToken: accessToken,
            athleteId: athlete.id
        )
    }
}

struct Athlete: Codable {
    let id: Int
    let username: String
    let resourceState: Int
    let firstname: String
    let lastname: String
    let bio: String?
    let city: String
    let state: String
    let country: String
    let sex: String
    let premium: Bool
    let summit: Bool
    let createdAt: String
    let updatedAt: String
    let badgeTypeId: Int
    let weight: Double
    let profileMedium: String
    let profile: String
    let friend: String?
    let follower: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case resourceState = "resource_state"
        case firstname
        case lastname
        case bio
        case city
        case state
        case country
        case sex
        case premium
        case summit
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case badgeTypeId = "badge_type_id"
        case weight
        case profileMedium = "profile_medium"
        case profile
        case friend
        case follower
    }
}

// MARK: - TokenRefreshRequest

struct TokenRefreshRequest: Content {
    let clientID: String
    let clientSecret: String
    let refreshToken: String
    let grantType: String

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case refreshToken = "refresh_token"
        case grantType = "grant_type"
    }
}

// MARK: - TokenRefreshResponse

struct TokenRefreshResponse: Content {
    let accessToken: String
    let expiresIn: Int
    let expiresAt: Int
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
    }

    func domainAccessToken(athleteId: Int) -> Domain.AccessToken {
        Domain.AccessToken(
            tokenType: "Bearer",
            expiresAt: Date(timeIntervalSince1970: TimeInterval(expiresAt)),
            refreshToken: refreshToken,
            accessToken: accessToken,
            athleteId: athleteId
        )
    }
}
