import Foundation

// MARK: - Activity

public struct Activity: Codable {
    public let id: Int64?
    public let name: String?
    public let distance: Float?
    public let movingTime: Int?
    public let elapsedTime: Int?
    public let totalElevationGain: Float?
    public let type: String?
    public let sportType: String?
    public let startLatlng: [Float]
    public let endLatlng: [Float]
    public let commute: Bool

    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case distance
        case movingTime = "moving_time"
        case elapsedTime = "elapsed_time"
        case totalElevationGain = "total_elevation_gain"
        case type
        case sportType = "sport_type"
        case startLatlng = "start_latlng"
        case endLatlng = "end_latlng"
        case commute
    }

    public init(
        id: Int64?,
        name: String?,
        distance: Float?,
        movingTime: Int?,
        elapsedTime: Int?,
        totalElevationGain: Float?,
        type: String?,
        sportType: String?,
        startLatlng: [Float],
        endLatlng: [Float],
        commute: Bool
    ) {
        self.id = id
        self.name = name
        self.distance = distance
        self.movingTime = movingTime
        self.elapsedTime = elapsedTime
        self.totalElevationGain = totalElevationGain
        self.type = type
        self.sportType = sportType
        self.startLatlng = startLatlng
        self.endLatlng = endLatlng
        self.commute = commute
    }
}
