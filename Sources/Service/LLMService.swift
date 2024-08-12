import Foundation
import OpenAI


struct LLMService {
    private let openAI: OpenAI
    
    init(openAIToken: String) {
        self.openAI = OpenAI(apiToken: openAIToken)
    }
    
    func generateTitle(for activityDetails: String) async -> String? {
        let query = CompletionsQuery(model: .gpt4_o_mini, prompt:
            """
            The following activity data is retrieved from the Strava API. Give it a fun title for Strava. Your response should only include the title itself and an appropriate emoji. The title should include the location where the activity took place. By looking at the segment, you can find out where it started and ended. Ommit any quotes in the title.
            
            \(activityDetails)
            """
        )
        
        return try? await openAI.completions(query: query).choices.first?.text
    }
}
