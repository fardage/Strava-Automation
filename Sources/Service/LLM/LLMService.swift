import Domain
import Foundation
@preconcurrency import OpenAI
import Vapor

public struct LLMService: LLMServing {
    private let openAI: OpenAI
    private let openWeatherMapToken: String
    private let httpReferrer: String
    private let client: Client
    private let logger: Vapor.Logger

    public init(
        openAIToken: String,
        openWeatherMapToken: String,
        httpReferrer: String,
        client: Client,
        logger: Vapor.Logger
    ) {
        openAI = OpenAI(apiToken: openAIToken)
        self.openWeatherMapToken = openWeatherMapToken
        self.httpReferrer = httpReferrer
        self.client = client
        self.logger = logger
    }

    public func generateTitle(for activity: Activity) async -> String? {
        let startLocation = await fetchGeoLocation(from: activity.startLatlng)
        let endLocation = await fetchGeoLocation(from: activity.endLatlng)

        let activityDetails = await formatActivityDetails(activity, startLocation: startLocation, endLocation: endLocation)
        let prompt = createPrompt(with: activityDetails)

        logger.debug("\(prompt)")

        return await fetchTitle(from: prompt)
    }

    private func fetchGeoLocation(from latlng: [Float]) async -> GeoLocation? {
        guard latlng.count == 2 else { return nil }

        let lat = latlng[0]
        let lon = latlng[1]
        let geoLookupURI = URI(string: "https://nominatim.openstreetmap.org/reverse.php?lat=\(lat)&lon=\(lon)&format=jsonv2")

        guard let response = try? await client.get(geoLookupURI, headers: ["Referer": httpReferrer]),
              let location = try? response.content.decode(GeoLocation.self)
        else {
            return nil
        }

        return location
    }

    private func formatActivityDetails(_ activity: Activity, startLocation: GeoLocation?, endLocation: GeoLocation?) async -> String {
        let distanceInKM = activity.distance.distanceAsChatInput
        let elapsedTime = activity.elapsedTime.timeAsChatInput
        let totalElevGain = activity.totalElevationGain.elevationAsChatInput
        let weatherDescription = await fetchWeatherDescription(for: endLocation)

        return """
        - Sport Type: \(activity.sportType ?? "N/A")
        - Start Time: \(activity.startDateLocal.asChatInput)
        - Is Commute: \(activity.commute)
        - Distance: \(distanceInKM)
        - Elapsed Time: \(elapsedTime)
        - Elevation Gain: \(totalElevGain)
        - Start Location (County): \(startLocation.locationAsChatInput)
        - End Location (County): \(endLocation.locationAsChatInput)
        - Weather: \(weatherDescription)
        """
    }

    private func createPrompt(with activityDetails: String) -> String {
        return """
        You are an athlete who has just completed a workout and want to create a compelling Strava activity title. Below is the data from your activity:

        \(activityDetails)

        Create a title that reflects notable aspects of the workout with understated tone. **Avoid making assumptions about why the activity was done. Include one emoji in the title, and do not enclose the title in quotes.**
        """
    }

    private func fetchTitle(from prompt: String) async -> String? {
        guard let message = ChatQuery.ChatCompletionMessageParam(role: .user, content: prompt) else {
            return nil
        }
        let query = ChatQuery(messages: [message], model: .gpt4_o_mini)

        do {
            return try await openAI.chats(query: query).choices.first?.message.content?.string
        } catch {
            return nil
        }
    }

    private func fetchWeatherDescription(for location: GeoLocation?) async -> String {
        guard let location else { return "N/A" }

        let weatherURI = URI(string: "https://api.openweathermap.org/data/2.5/weather?&units=metric&lat=\(location.lat)&lon=\(location.lon)&appid=\(openWeatherMapToken)")

        do {
            let response = try await client.get(weatherURI)
            let weatherData = try response.content.decode(OWWeather.self)
            let weatherCondition = weatherData.weather.first?.description ?? ""

            return "\(weatherCondition) and temperature feels like \(weatherData.main.feelsLike)°C"
        } catch {
            logger.error("\(error)")
            return "N/A"
        }
    }
}

// MARK: - Formatting

private extension Date? {
    var asChatInput: String {
        guard let self else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        return dateFormatter.string(from: self)
    }
}

private extension Float? {
    var distanceAsChatInput: String {
        guard let distance = self else { return "N/A" }
        return String(distance / 1000) + " km"
    }
}

private extension Int? {
    var timeAsChatInput: String {
        guard let time = self else { return "N/A" }
        return String(time / 60) + " minutes"
    }
}

private extension Float? {
    var elevationAsChatInput: String {
        guard let elevation = self else { return "N/A" }
        return String(elevation) + " meters"
    }
}

private extension GeoLocation? {
    var locationAsChatInput: String {
        guard let address = self?.address else { return "N/A" }
        return "\(address.suburb), \(address.city)"
    }
}
