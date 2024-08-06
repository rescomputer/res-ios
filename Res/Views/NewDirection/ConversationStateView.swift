import SwiftUI

struct ConversationStateView: View {
    @Binding var callState: CallManagerNewDirection.CallState
    @Binding var conversationState: CallManagerNewDirection.ConversationState
    var personaName: String

    var body: some View {
        Text(stateText)
            .font(.body)
            .foregroundColor(.white.opacity(0.7))
            .padding()
    }

    private var stateText: String {
        switch (callState, conversationState) {
        case (.loading, _):
            return "calling \(personaName)"
        case (.started, .userSpeaking):
            return "*listening*"
        case (.started, .null):
            return "*listening*"
        case (.started, .assistantSpeaking):
            return "*speaking*"
        case (.started, .assistantThinking):
            return "*thinking*"
        default:
            return "calling \(personaName)"
        }
    }
}

struct ConversationStatePreview: View {
    @StateObject private var callManager = CallManagerNewDirection()
    
    var body: some View {
        ConversationStateView(
            callState: $callManager.callState,
            conversationState: $callManager.conversationState,
            personaName: "Steve"
        )
    }
}

// Preview
struct ConversationStatePreview_Previews: PreviewProvider {
    static var previews: some View {
        ConversationStatePreview()
    }
}
