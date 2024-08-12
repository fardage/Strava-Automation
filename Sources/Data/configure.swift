import Foundation
import Vapor

public func setupDb(_ app: Application) async throws {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(AccessToken.Migration())

    try await app.autoMigrate()
}
