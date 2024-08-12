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

public protocol LLMServing: Sendable {
    func generateTitle(for activity: Activity) async -> String?
}

public struct UpdateActivityFeature: Sendable {
    private let configuration: Configuration
    private let logger: Logger
    private let tokenStore: TokenStoring
    private let tokenService: TokenServing
    private let stravaDataProvider: StravaDataProviding
    private let llmService: LLMServing

    public init(
        configuration: Configuration,
        logger: Logger,
        tokenStore: TokenStoring,
        tokenService: TokenServing,
        stravaDataProvider: StravaDataProviding,
        llmService: LLMServing
    ) {
        self.configuration = configuration
        self.logger = logger
        self.tokenStore = tokenStore
        self.tokenService = tokenService
        self.stravaDataProvider = stravaDataProvider
        self.llmService = llmService
    }

    public func execute(event: EventData) async {
        guard event.aspectType == .create else {
            logger.info("Ignoring non create event")
            return
        }

        guard let accessToken = try? await getAccessToken(for: event.ownerID) else {
            logger.error("No access token for id found")
            return
        }

        logger.debug("Access token: \(accessToken.accessToken)")

        await markAsCommuteIfNeeded(eventID: event.objectID, accessToken: accessToken)
        await updateTitle(eventID: event.objectID, accessToken: accessToken)
    }

    private func updateTitle(eventID: Int, accessToken: AccessToken) async {
        guard let activity = try? await stravaDataProvider.getActivityById(eventID, accessToken: accessToken.accessToken)
        else {
            logger.error("Could not fetch activity details")
            return
        }

        let title = await llmService.generateTitle(for: activity)

        await stravaDataProvider.updateActivity(
            eventID,
            accessToken: accessToken.accessToken,
            commute: nil,
            hideFromHome: nil,
            description: nil,
            name: title
        )
        logger.info("Generated \(String(describing: title)) for activity \(eventID)")
    }

    private func markAsCommuteIfNeeded(eventID: Int, accessToken: AccessToken) async {
        guard let activity = try? await stravaDataProvider.getActivityById(eventID, accessToken: accessToken.accessToken),
              let distanceInMeters = activity.distance
        else {
            logger.error("Could not fetch activity details")
            return
        }

        let isRide = activity.sportType == "Ride"
        let isShortRide = distanceInMeters < configuration.maxCommuteDistanceInMeter

        if isRide && isShortRide {
            await stravaDataProvider.updateActivity(
                eventID,
                accessToken: accessToken.accessToken,
                commute: true,
                hideFromHome: true,
                description: nil,
                name: nil
            )
            logger.info("Marked activity \(eventID) as commute")
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
            logger.info("Access token refreshed")
            return refreshedToken
        } else {
            return accessToken
        }
    }
}
