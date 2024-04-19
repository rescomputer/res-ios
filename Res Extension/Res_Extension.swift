//
//  Res_Extension.swift
//  Res Extension
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

struct ResEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            ResSmallEntryView(entry: entry)
        case .systemMedium:
            ResMediumEntryView(entry: entry)
        case .systemLarge:
            ResLargeEntryView(entry: entry)
        case .accessoryRectangular:
            ResAccessoryRectangularEntryView(entry: entry)
        case .accessoryCircular:
            ResAccessoryCircularEntryView(entry: entry)
        @unknown default:
            fatalError("Unsupported widget family")
        }
    }
}

struct ResSmallEntryView: View {
    var entry: Provider.Entry

    var body: some View {
            HStack{
                Image(systemName: "waveform")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                
                Spacer()
            }       
            HStack {
                Text("Start Conversation")
                    .foregroundColor(.white)
                    .font(.system(size: 20, design: .rounded))

                Spacer()
            }
        .containerBackground(for: .widget) {
            // Customize the background view for the small widget
            Color(red: 0.25, green: 0.60, blue: 0.93)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ResMediumEntryView: View {
    var entry: Provider.Entry

      var body: some View {
            HStack{
                Spacer()
                Image(systemName: "waveform")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                
                Spacer()
            }       
            HStack {
                Spacer()
                Text("Start Conversation")
                    .foregroundColor(.white)
                    .font(.system(size: 26, design: .rounded))
                Spacer()
            }
        .containerBackground(for: .widget) {
            // Customize the background view for the small widget
            Color(red: 0.25, green: 0.60, blue: 0.93)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ResLargeEntryView: View {
    var entry: Provider.Entry

    var body: some View {
            HStack{
                Spacer()
                Image(systemName: "waveform")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                
                Spacer()
            }       
            HStack {
                Spacer()
                Text("Start Conversation")
                    .foregroundColor(.white)
                    .font(.system(size: 30, design: .rounded))
                Spacer()
            }
        .containerBackground(for: .widget) {
            // Customize the background view for the small widget
            Color(red: 0.25, green: 0.60, blue: 0.93)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ResAccessoryRectangularEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .mask(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thickMaterial).opacity(0.3)
                    )

                Text("Start Conversation")
                    .font(.system(size: 14, design: .rounded))
            }
        }
        .containerBackground(for: .widget) {
            // Customize the background view for the accessory rectangular widget
        }
    }
}

struct ResAccessoryCircularEntryView: View {
    var entry: Provider.Entry

    var body: some View {
         GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.height)
//                    .background(.ultraThinMaterial)
                Text("Talk")
                    .font(.system(size: 14, design: .rounded))
            }
        }
        .containerBackground(for: .widget) {
            // Customize the background view for the accessory circular widget
        }
    }
}

struct Res_Extension: Widget {
    let kind: String = "Res_Extension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ResEntryView(entry: entry)
        }
        .configurationDisplayName("Res Widget")
        .description("Start a conversation with Res")
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
    Res_Extension()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
