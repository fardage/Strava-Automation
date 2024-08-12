import Foundation

public struct AccessToken {
    public var id: UUID?
    public var tokenType: String
    public var expiresAt: Date
    public var refreshToken: String
    public var accessToken: String
    public var athleteId: Int

    public init(
        id: UUID? = nil,
        tokenType: String,
        expiresAt: Date,
        refreshToken: String,
        accessToken: String,
        athleteId: Int
    ) {
        self.id = id
        self.tokenType = tokenType
        self.expiresAt = expiresAt
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.athleteId = athleteId
    }
}
