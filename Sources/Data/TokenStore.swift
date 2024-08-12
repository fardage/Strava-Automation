import Domain
import Fluent
import Foundation

public struct TokenStore: TokenStoring {
    private let database: Database

    public init(database: Database) {
        self.database = database
    }

    public func set(_ accessToken: Domain.AccessToken) async throws {
        try await AccessToken.query(on: database)
            .filter(\.$athleteId == accessToken.athleteId)
            .delete()

        try await AccessToken(
            tokenType: accessToken.tokenType,
            expiresAt: accessToken.expiresAt,
            refreshToken: accessToken.refreshToken,
            accessToken: accessToken.accessToken,
            athleteId: accessToken.athleteId
        ).save(on: database)
    }

    public func get(id: Int) async throws -> Domain.AccessToken? {
        let queryResult = try await AccessToken.query(on: database)
            .filter(\.$athleteId == id)
            .first()

        guard let queryResult else {
            return nil
        }

        return Domain.AccessToken(
            tokenType: queryResult.tokenType,
            expiresAt: queryResult.expiresAt,
            refreshToken: queryResult.refreshToken,
            accessToken: queryResult.accessToken,
            athleteId: queryResult.athleteId
        )
    }
}
