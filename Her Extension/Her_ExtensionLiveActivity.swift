import ActivityKit
import WidgetKit
import SwiftUI

struct Her_ExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var sfSymbolName: String
    }
    
    var name: String
}

struct Her_ExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Her_ExtensionAttributes.self) { context in
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

extension Her_ExtensionAttributes {
    fileprivate static var preview: Her_ExtensionAttributes {
        Her_ExtensionAttributes(name: "World")
    }
}

extension Her_ExtensionAttributes.ContentState {
    fileprivate static var connecting: Her_ExtensionAttributes.ContentState {
        Her_ExtensionAttributes.ContentState(sfSymbolName: "ellipsis")
    }
    
    fileprivate static var activeCall: Her_ExtensionAttributes.ContentState {
        Her_ExtensionAttributes.ContentState(sfSymbolName: "waveform.and.person.filled")
    }
}

#Preview("Notification", as: .content, using: Her_ExtensionAttributes.preview) {
    Her_ExtensionLiveActivity()
} contentStates: {
    Her_ExtensionAttributes.ContentState.connecting
    Her_ExtensionAttributes.ContentState.activeCall
}
