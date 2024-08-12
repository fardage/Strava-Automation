import CoreLocation
import Foundation

public protocol StravaDataProviding: Sendable {
    func getActivityById(_ id: Int, accessToken: String) async throws -> Activity?
    func updateActivity(
        _ id: Int,
        accessToken: String,
        commute: Bool?,
        hideFromHome: Bool?,
        description: String?,
        name: String?
    ) async
}

public struct UpdateActivityFeature: Sendable {
    private let configuration: Configuration
    private let logger: Logger
    private let tokenStore: TokenStoring
    private let tokenService: TokenServing
    private let stravaDataProvider: StravaDataProviding

    public init(
        configuration: Configuration,
        logger: Logger,
        tokenStore: TokenStoring,
        tokenService: TokenServing,
        stravaDataProvider: StravaDataProviding
    ) {
        self.configuration = configuration
        self.logger = logger
        self.tokenStore = tokenStore
        self.tokenService = tokenService
        self.stravaDataProvider = stravaDataProvider
    }

    public func execute(event: EventData) async {
        guard let accessToken = try? await getAccessToken(for: event.ownerID) else {
            logger.error("No access token for id found")
            return
        }

        guard let activity = try? await stravaDataProvider.getActivityById(event.objectID, accessToken: accessToken.accessToken),
              let distanceInMeters = activity.distance
        else {
            logger.error("Could not fetch activity details")
            return
        }

        let isRide = activity.sportType == "Ride"
        let isShortRide = distanceInMeters < configuration.maxCommuteDistanceInMeter

        if isRide && isShortRide {
            await stravaDataProvider.updateActivity(
                event.objectID,
                accessToken: accessToken.accessToken,
                commute: true,
                hideFromHome: true,
                description: nil,
                name: nil
            )
        }
    }

    private func getAccessToken(for athleteID: Int) async throws -> AccessToken? {
        guard let accessToken = try? await tokenStore.get(id: athleteID) else {
            logger.error("No access token for id found")
            return nil
        }

        if accessToken.expiresAt < Date.now {
            let refreshedToken = try await tokenService.refreshAccessToken(
                refreshToken: accessToken.refreshToken,
                athleteId: athleteID
            )
            try await tokenStore.set(refreshedToken)
            return refreshedToken
        } else {
            return accessToken
        }
    }
}
