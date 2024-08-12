import Domain
import Foundation
import Vapor

public struct TokenService: TokenServing {
    private let client: Client
    private let clientID: String
    private let clientSecret: String
    private let redirectURI: String
    private let stravaAuthURI = URI(string: "https://www.strava.com/oauth/token")

    public let authorizationURL: String

    public init(
        client: Client,
        clientID: String,
        clientSecret: String,
        redirectURI: String
    ) {
        self.client = client
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI

        authorizationURL = "https://www.strava.com/oauth/authorize?" +
            "response_type=code&" +
            "client_id=\(clientID)&" +
            "redirect_uri=\(redirectURI)?auth_redirect=true&" +
            "scope=read,activity:read_all,activity:write"
    }

    public func fetchAccessToken(code: String) async throws -> Domain.AccessToken {
        let uri = URI(string: "https://www.strava.com/oauth/token")
        let content = CodenRequest(
            clientID: clientID,
            clientSecret: clientSecret,
            code: code,
            grantType: "authorization_code"
        )

        let response = try await client.post(uri, content: content)
        let accessToken = try response.content.decode(AccessToken.self)

        return accessToken.domainAccessToken
    }

    public func refreshAccessToken(refreshToken: String, athleteId: Int) async throws -> Domain.AccessToken {
        let uri = URI(string: "https://www.strava.com/oauth/token")
        let content = TokenRefreshRequest(
            clientID: clientID,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            grantType: "refresh_token"
        )

        let response = try await client.post(uri, content: content)
        let refreshedToken = try response.content.decode(TokenRefreshResponse.self)

        return refreshedToken.domainAccessToken(athleteId: athleteId)
    }
}
