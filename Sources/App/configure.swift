import Data
import Domain
import Service
import StravaKit
import Vapor

public func configure(_ app: Application) async throws {
    try await setupDb(app)

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let envConfiguration = EnvConfiguration()
    let logger = TraceLogger(vaporLogger: app.logger)
    let tokenService = TokenService(
        client: app.client,
        clientID: envConfiguration.clientID,
        clientSecret: envConfiguration.clientSecret,
        redirectURI: envConfiguration.redirectURI
    )
    let tokenStore = TokenStore(database: app.db)
    let stravaDataProvider = StravaDataProvider()

    let updateActivityFeature = UpdateActivityFeature(
        configuration: envConfiguration,
        logger: logger,
        tokenStore: tokenStore,
        tokenService: tokenService,
        stravaDataProvider: stravaDataProvider
    )
    let authFeature = AuthFeature(
        logger: logger,
        tokenService: tokenService,
        tokenStore: tokenStore
    )
    let verifyWebhookFeature = VerifyWebhookFeature(
        configuration: envConfiguration,
        logger: logger
    )

    // register routes
    try app.register(collection: WebhookController(
        updateActivityFeature: updateActivityFeature,
        verifyWebhookFeature: verifyWebhookFeature
    ))
    try app.register(collection: AuthController(authFeature: authFeature))
    try app.register(collection: HomeController())
}
