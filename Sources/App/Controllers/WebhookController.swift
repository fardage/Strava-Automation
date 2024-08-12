import Domain
import Foundation
import Vapor

struct WebhookController: Sendable, RouteCollection {
    private let updateActivityFeature: UpdateActivityFeature
    private let verifyWebhookFeature: VerifyWebhookFeature

    init(
        updateActivityFeature: UpdateActivityFeature,
        verifyWebhookFeature: VerifyWebhookFeature
    ) {
        self.updateActivityFeature = updateActivityFeature
        self.verifyWebhookFeature = verifyWebhookFeature
    }

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let webhook = routes.grouped("webhook")
        webhook.get(use: verify)
        webhook.post(use: receiveEvent)
    }

    @Sendable
    private func receiveEvent(req: Request) throws -> HTTPStatus {
        guard let webhookEvent = try? req.content.decode(WebhookEvent.self)
        else {
            req.logger.error("Could not decode request to WebhookEvent")
            return .internalServerError
        }

        Task { await updateActivityFeature.execute(event: webhookEvent.eventData) }
        return .ok
    }

    @Sendable
    private func verify(req: Request) throws -> HubResponse {
        guard let hubRequest = try? req.query.decode(HubRequest.self)
        else {
            req.logger.error("Could not decode request to HubRequest")
            throw Abort(.forbidden)
        }

        switch verifyWebhookFeature.execute(hub: hubRequest.hub) {
        case let .success(result):
            return result.hubResponse
        case .failure:
            throw Abort(.forbidden)
        }
    }
}
