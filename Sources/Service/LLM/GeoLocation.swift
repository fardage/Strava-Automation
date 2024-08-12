import Foundation
import Vapor

// MARK: - GeoLocation

public struct GeoLocation: Content {
    public let placeID: Int
    public let licence: String
    public let osmType: String
    public let osmID: Int
    public let lat: String
    public let lon: String
    public let category: String
    public let type: String
    public let placeRank: Int
    public let importance: Double
    public let addresstype: String
    public let name: String
    public let displayName: String
    public let address: Address
    public let boundingbox: [String]

    public enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case lat
        case lon
        case category
        case type
        case placeRank = "place_rank"
        case importance
        case addresstype
        case name
        case displayName = "display_name"
        case address
        case boundingbox
    }

    public init(placeID: Int, licence: String, osmType: String, osmID: Int, lat: String, lon: String, category: String, type: String, placeRank: Int, importance: Double, addresstype: String, name: String, displayName: String, address: Address, boundingbox: [String]) {
        self.placeID = placeID
        self.licence = licence
        self.osmType = osmType
        self.osmID = osmID
        self.lat = lat
        self.lon = lon
        self.category = category
        self.type = type
        self.placeRank = placeRank
        self.importance = importance
        self.addresstype = addresstype
        self.name = name
        self.displayName = displayName
        self.address = address
        self.boundingbox = boundingbox
    }
}

// MARK: - Address

public struct Address: Codable {
    public let houseNumber: String
    public let road: String
    public let suburb: String
    public let city: String
    public let county: String
    public let state: String
    public let iso31662Lvl4: String
    public let postcode: String
    public let country: String
    public let countryCode: String

    public enum CodingKeys: String, CodingKey {
        case houseNumber = "house_number"
        case road
        case suburb
        case city
        case county
        case state
        case iso31662Lvl4 = "ISO3166-2-lvl4"
        case postcode
        case country
        case countryCode = "country_code"
    }

    public init(houseNumber: String, road: String, suburb: String, city: String, county: String, state: String, iso31662Lvl4: String, postcode: String, country: String, countryCode: String) {
        self.houseNumber = houseNumber
        self.road = road
        self.suburb = suburb
        self.city = city
        self.county = county
        self.state = state
        self.iso31662Lvl4 = iso31662Lvl4
        self.postcode = postcode
        self.country = country
        self.countryCode = countryCode
    }
}
