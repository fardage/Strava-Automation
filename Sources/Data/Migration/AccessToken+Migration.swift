import Fluent
import Foundation

extension AccessToken {
    struct Migration: AsyncMigration {
        init() {}

        func prepare(on database: Database) async throws {
            try await database.schema("access_tokens")
                .id()
                .field("token_type", .string)
                .field("expires_at", .date)
                .field("refresh_token", .string)
                .field("access_token", .string)
                .field("athlete_id", .int)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.schema("access_tokens").delete()
        }
    }
}
