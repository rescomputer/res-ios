//
//  Her_Extension.swift
//  Her Extension
//
//  Created by Richard Burton on 19/03/2024.
//

import WidgetKit
import SwiftUI
import UIKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct HerEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            HerSmallEntryView(entry: entry)
        case .systemMedium:
            HerMediumEntryView(entry: entry)
        case .systemLarge:
            HerLargeEntryView(entry: entry)
        case .accessoryRectangular:
            HerAccessoryRectangularEntryView(entry: entry)
        case .accessoryCircular:
            HerAccessoryCircularEntryView(entry: entry)
        @unknown default:
            fatalError("Unsupported widget family")
        }
    }
}

struct HerSmallEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("flow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .scaleEffect(1.3)
            
            Text("Start Conversation")
        }
        .containerBackground(for: .widget) {
            // Customize the background view for the small widget
            Color.white
        }
    }
}

struct HerMediumEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("flow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .scaleEffect(1.3)
            
            Text("Start Conversation")
        }
        .containerBackground(for: .widget) {
            // Customize the background view for the medium widget
            Color.white
        }
    }
}

struct HerLargeEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("flow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .scaleEffect(1.3)
            
            Text("Start Conversation")
        }
        .containerBackground(for: .widget) {
            // Customize the background view for the large widget
            Color.white
        }
    }
}

struct HerAccessoryRectangularEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("flow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .scaleEffect(1.3)
            
            Text("Start Conversation")
        }
        .containerBackground(for: .widget) {
            // Customize the background view for the accessory rectangular widget
            Color.white
        }
    }
}

struct HerAccessoryCircularEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("flow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.3)
                .scaleEffect(1.3)
            
            Text("Chat")
        }
        .containerBackground(for: .widget) {
            // Customize the background view for the accessory rectangular widget
            Color.white
        }
    }
}

//struct HerAccessorySquareEntryView: View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        ZStack {
//            Image("flow")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .opacity(0.3)
//                .scaleEffect(1.3)
//            
//            Text("Chat")
//        }
//        .containerBackground(for: .widget) {
//            // Customize the background view for the accessory rectangular widget
//            Color.white
//        }
//    }
//}

//struct Her_ExtensionEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        ZStack {
//            Image("flow")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .opacity(0.3)
//                .offset(y: -20)
//                .scaleEffect(1.3)
//            
//            Text("Start Conversation")
//        }
//    }
//}

struct Her_Extension: Widget {
    let kind: String = "Her_Extension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            HerEntryView(entry: entry)
        }
        .configurationDisplayName("Her Widget")
        .description("Start a conversation with Her")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular, .accessoryCircular])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    Her_Extension()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
