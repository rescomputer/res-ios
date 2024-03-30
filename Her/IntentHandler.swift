//
//  IntentHandler.swift
//  Her
//
//  Created by Richard Burton on 30/03/2024.
//

import Foundation
import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        // This is the entry point for handling intents
        if intent is StartCallIntent {
            // Return an instance of StartCallIntentHandling
            return self
        }
        
        // If the intent is not handled, return the default handler
        return self
    }
}

extension IntentHandler: StartCallIntentHandling {
    func handle(intent: StartCallIntent, completion: @escaping (StartCallIntentResponse) -> Void) {
        // Handle the StartCallIntent here
        
        // Call the startCallFromShortcut() function from the CallManager
        CallManager().startCallFromShortcut()
        
        // Respond with a success message
        let response = StartCallIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
}
