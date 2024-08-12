import Foundation

public struct EventData: Sendable {
    public enum AspectType: String, Sendable {
        case create, update, delete
    }

    public init(
        aspectType: AspectType,
        eventTime: Int,
        objectID: Int,
        objectType: String,
        ownerID: Int,
        subscriptionID: Int
    ) {
        self.aspectType = aspectType
        self.eventTime = eventTime
        self.objectID = objectID
        self.objectType = objectType
        self.ownerID = ownerID
        self.subscriptionID = subscriptionID
    }

    public var aspectType: AspectType
    public var eventTime: Int
    public var objectID: Int
    public var objectType: String
    public var ownerID: Int
    public var subscriptionID: Int
}
