import FluentSQLiteDriver
import Foundation

/// https://blog.vapor.codes/posts/fluent-models-and-sendable/
public final class AccessToken: @unchecked Sendable, Model {
    public static let schema = "access_tokens"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "token_type")
    public var tokenType: String

    @Field(key: "expires_at")
    public var expiresAt: Date

    @Field(key: "refresh_token")
    public var refreshToken: String

    @Field(key: "access_token")
    public var accessToken: String

    @Field(key: "athlete_id")
    public var athleteId: Int

    public init() {}

    public init(id: UUID? = nil, tokenType: String, expiresAt: Date, refreshToken: String, accessToken: String, athleteId: Int) {
        self.id = id
        self.tokenType = tokenType
        self.expiresAt = expiresAt
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.athleteId = athleteId
    }
}
