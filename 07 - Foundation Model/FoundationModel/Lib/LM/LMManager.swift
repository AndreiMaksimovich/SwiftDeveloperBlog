//
//  LMManager.swift
//  SwiftDeveloperBlog
//

import FoundationModels
import Foundation

@Observable
public class LMManager {
    public static let shared: LMManager = .init()
    private static let logTag = "[LMManager]"
    
    private(set) var state: State = .ok
    private let model: SystemLanguageModel = .init(useCase: .general, guardrails: .default)
    
    public var isAvailable: Bool {
        if case .ok = state {
            return true
        } else {
            return false
        }
    }
    
    private init() {
        if case .unavailable(let reason) = model.availability {
            state = .modelNotAvailable(reason: reason)
            return
        }
    }
    
    private let extractDateFromUserInputPrompt = """
        # Your task:
        1. Read the user's input and identify any date information it contains.
        2. Convert the detected information into a date and extract its numeric date components:
          - year: four-digit year (YYYY)
          - month: numeric month (1-12)
          - day: numeric day (1-31)
        3. Pass these numeric values to the LMToolDateExtractor tool using:
          - year
          - month
          - day
        4. Return ONLY the result produced by LMToolDateExtractor.
        5. The final response must be valid JSON.
        6. Do not include explanations, reasoning, markdown, or additional text.
        7. If multiple dates are present, use the primary date referenced by the user.

        # Output requirements:
        1. Return only JSON.
        2. No code fences.
        3. No extra fields unless returned by LMToolDateExtractor.

        # User input:
        -------------------------
        {UserInput}
        """
    
    public func extractDateFromUserInputTask(userInput: String) throws -> Task<Date?, any Error> {
        if case .modelNotAvailable(let reason) = state {
            throw LMError.modelNotAvailable(reason: reason)
        }
        
        let task: Task<Date?, any Error> = Task {
            let lmSession = LanguageModelSession(
                model: model,
                tools: [LMToolDateExtractor()],
                instructions: "Current date is: \(Date.now.formatted())"
            )
            
            let prompt = extractDateFromUserInputPrompt.replacingOccurrences(of: "{UserInput}", with: userInput)
            
            let result = try await lmSession.respond(to: prompt, generating: LMToolDateExtractor.Arguments.self)
            let dateComponents = result.content
            
            return Calendar.current.date(from: .init(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day))
        }
        
        return task
    }
    
    public func extractDateFromUserInput(userInput: String) async throws -> Date? {
        let task = try extractDateFromUserInputTask(userInput: userInput)
        return try await task.value
    }
    
    public enum State {
        case ok
        case modelNotAvailable(reason: SystemLanguageModel.Availability.UnavailableReason)
    }
    
    public enum LMError: Error {
        case modelNotAvailable(reason: SystemLanguageModel.Availability.UnavailableReason)
        case failedToInitializedLMSession
    }
}
