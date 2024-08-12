import Foundation
import Vapor

struct HomeController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        routes.get("auth-end", use: showAuthDone)
    }

    @Sendable
    private func showAuthDone(req _: Request) -> Response {
        return Response(status: .ok, body: "Authorization Done")
    }
}
