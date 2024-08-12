import Foundation

public protocol TokenServing: Sendable {
    var authorizationURL: String { get }
    func fetchAccessToken(code: String) async throws -> Domain.AccessToken
    func refreshAccessToken(refreshToken: String, athleteId: Int) async throws -> Domain.AccessToken
}

public protocol TokenStoring: Sendable {
    func set(_ accessToken: AccessToken) async throws
    func get(id: Int) async throws -> AccessToken?
}

public struct AuthFeature: Sendable {
    private let logger: Logger
    private let tokenService: TokenServing
    private let tokenStore: TokenStoring

    public var authorizationURI: String {
        tokenService.authorizationURL
    }

    public init(
        logger: Logger,
        tokenService: TokenServing,
        tokenStore: TokenStoring
    ) {
        self.logger = logger
        self.tokenService = tokenService
        self.tokenStore = tokenStore
    }

    public func authenticate(code: String) async -> Result<Void, Error> {
        do {
            let accessToken = try await tokenService.fetchAccessToken(code: code)
            try await tokenStore.set(accessToken)
            return .success(())
        } catch {
            logger.error("Could not fetch access token\(error)")
            return .failure(error)
        }
    }
}
