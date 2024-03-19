//
//  Her_ExtensionLiveActivity.swift
//  Her Extension
//
//  Created by Richard Burton on 19/03/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Her_ExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Her_ExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Her_ExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Her_ExtensionAttributes {
    fileprivate static var preview: Her_ExtensionAttributes {
        Her_ExtensionAttributes(name: "World")
    }
}

extension Her_ExtensionAttributes.ContentState {
    fileprivate static var smiley: Her_ExtensionAttributes.ContentState {
        Her_ExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Her_ExtensionAttributes.ContentState {
         Her_ExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Her_ExtensionAttributes.preview) {
   Her_ExtensionLiveActivity()
} contentStates: {
    Her_ExtensionAttributes.ContentState.smiley
    Her_ExtensionAttributes.ContentState.starEyes
}
