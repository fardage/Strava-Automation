import Domain
import Foundation
import Vapor

struct EnvConfiguration: Configuration {
    var maxCommuteDistanceInMeter: Float = {
        let distance = Environment.get("MAX_COMMUTE_METER_DISTANCE")!
        return Float(distance)!
    }()

    var verifyToken: String = Environment.get("VERIFY_TOKEN")!

    var clientSecret: String = Environment.get("CLIENT_SECRET")!

    var clientID: String = Environment.get("CLIENT_ID")!

    var redirectURI: String = Environment.get("REDIRECT_URI")!
}
