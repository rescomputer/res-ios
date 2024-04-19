import ActivityKit
import WidgetKit
import SwiftUI

struct Res_ExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var sfSymbolName: String
    }
    
    var name: String
}

struct Res_ExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Res_ExtensionAttributes.self) { context in
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: context.state.sfSymbolName)
                        .imageScale(.large)
                        .font(.system(size: 30))
                        .foregroundColor(context.state.sfSymbolName == "ellipsis" ? .gray : .green)
                    
                    Text("Conversation with Res")
                        .font(.headline)
                        .padding(.leading, 8)
                }
            }
            .padding()
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(alignment: .top) {
                        Image(systemName: context.state.sfSymbolName)
                            .imageScale(.large)
                            .font(.system(size: 30))
                            .foregroundColor(context.state.sfSymbolName == "ellipsis" ? .gray : .green)
                        
                        Text("Conversation with Res")
                            .font(.headline)
                            .padding(.leading, 8)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Res")
                        .font(.subheadline)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Conversation in progress")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } compactLeading: {
                Image(systemName: context.state.sfSymbolName)
                    .imageScale(.small)
                    .foregroundColor(context.state.sfSymbolName == "ellipsis" ? .gray : .green)
            } compactTrailing: {
                Text("Res")
                    .font(.caption)
            } minimal: {
                Image(systemName: context.state.sfSymbolName)
                    .imageScale(.small)
                    .foregroundColor(context.state.sfSymbolName == "ellipsis" ? .gray : .green)
            }
        }
    }
}

extension Res_ExtensionAttributes {
    fileprivate static var preview: Res_ExtensionAttributes {
        Res_ExtensionAttributes(name: "World")
    }
}

extension Res_ExtensionAttributes.ContentState {
    fileprivate static var connecting: Res_ExtensionAttributes.ContentState {
        Res_ExtensionAttributes.ContentState(sfSymbolName: "ellipsis")
    }
    
    fileprivate static var activeCall: Res_ExtensionAttributes.ContentState {
        Res_ExtensionAttributes.ContentState(sfSymbolName: "waveform.and.person.filled")
    }
}

#Preview("Notification", as: .content, using: Res_ExtensionAttributes.preview) {
    Res_ExtensionLiveActivity()
} contentStates: {
    Res_ExtensionAttributes.ContentState.connecting
    Res_ExtensionAttributes.ContentState.activeCall
}
