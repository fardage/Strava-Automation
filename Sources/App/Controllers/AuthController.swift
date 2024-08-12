import Domain
import Foundation
import Vapor

struct AuthController: RouteCollection {
    private let authFeature: AuthFeature

    init(authFeature: AuthFeature) {
        self.authFeature = authFeature
    }

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.get(use: authorize)
    }

    @Sendable
    private func authorize(req: Request) async throws -> Response {
        let isAuthRedirect = req.query["auth_redirect"] == "true"
        let code: String? = req.query["code"]

        if isAuthRedirect, let code {
            switch await authFeature.authenticate(code: code) {
            case .success:
                return req.redirect(to: "/auth-end")
            case .failure:
                return req.redirect(to: authFeature.authorizationURI)
            }
        } else {
            return req.redirect(to: authFeature.authorizationURI)
        }
    }
}
