import Domain
import Foundation
import Vapor

struct WebhookEvent: Content {
    enum AspectType: String, Content {
        case create, update, delete

        var dataAspectType: EventData.AspectType {
            switch self {
            case .create:
                .create
            case .update:
                .update
            case .delete:
                .delete
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case aspectType = "aspect_type"
        case eventTime = "event_time"
        case objectID = "object_id"
        case objectType = "object_type"
        case ownerID = "owner_id"
        case subscriptionID = "subscription_id"
    }

    var aspectType: AspectType
    var eventTime: Int
    var objectID: Int
    var objectType: String
    var ownerID: Int
    var subscriptionID: Int

    var eventData: EventData {
        EventData(
            aspectType: aspectType.dataAspectType,
            eventTime: eventTime,
            objectID: objectID,
            objectType: objectType,
            ownerID: ownerID,
            subscriptionID: subscriptionID
        )
    }
}
