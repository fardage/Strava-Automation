import Domain
import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

public struct StravaDataProvider: StravaDataProviding {
    public init() {}

    public func getActivityById(_ id: Int, accessToken: String) async throws -> Domain.Activity? {
        let client = Client(
            serverURL: try! Servers.server1(),
            transport: AsyncHTTPClientTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: "Bearer " + accessToken)]
        )

        let path = Operations.getActivityById.Input.Path(id: Int64(id))
        let response = try await client.getActivityById(path: path)

        guard case let .ok(okResponse) = response,
              case let .json(result) = okResponse.body
        else {
            print("Error: \(response)")
            return nil
        }

        return result.domainActivity
    }

    public func updateActivity(
        _ id: Int,
        accessToken: String,
        commute: Bool? = nil,
        hideFromHome: Bool? = nil,
        description: String? = nil,
        name: String? = nil
    ) async {
        let client = Client(
            serverURL: try! Servers.server1(),
            transport: AsyncHTTPClientTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: "Bearer " + accessToken)]
        )

        let path = Operations.updateActivityById.Input.Path(id: Int64(id))
        let body = Operations.updateActivityById.Input.Body.json(
            .init(
                commute: commute,
                hide_from_home: hideFromHome,
                description: description,
                name: name
            )
        )
        let response = try? await client.updateActivityById(
            path: path,
            body: body
        )

        guard case let .ok(okResponse) = response,
              case .json = okResponse.body
        else {
            print("Error: \(String(describing: response))")
            return
        }
    }
}

struct UpdateActivity {
    let commute: Bool
}

extension Components.Schemas.DetailedActivity {
    var domainActivity: Domain.Activity {
        .init(
            id: value1.value1.id,
            name: value1.value2.name,
            distance: value1.value2.distance,
            movingTime: value1.value2.moving_time,
            elapsedTime: value1.value2.elapsed_time,
            totalElevationGain: value1.value2.total_elevation_gain,
            type: value1.value2._type?.rawValue,
            sportType: value1.value2.sport_type?.rawValue,
            startLatlng: value1.value2.start_latlng ?? [Float](),
            endLatlng: value1.value2.end_latlng ?? [Float](),
            commute: value1.value2.commute ?? false
        )
    }
}
