//
//  LifeProgressWidget.swift
//  LifeProgressWidgetExtension
//
//  Created by Bartosz Król on 09/04/2023.
//

import WidgetKit
import SwiftUI
import Dependencies
import Combine

struct LifeProgressProvider: TimelineProvider {
    
    let userSettingsClient = UserSettingsClient.liveValue
    
    func placeholder(in context: Context) -> LifeProgressEntry {
        LifeProgressEntry(life: Life.mock)
    }

    func getSnapshot(in context: Context, completion: @escaping (LifeProgressEntry) -> ()) {
        // Get the user's data
        let lifeExpectancy = userSettingsClient.getLifeExpectancy()
        let birthday = userSettingsClient.getBirthday()
        let life = Life(birthday: birthday, lifeExpectancy: lifeExpectancy)
        // Update the timeline entry
        let entry = LifeProgressEntry(life: life)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Get the user's data
        let lifeExpectancy = userSettingsClient.getLifeExpectancy()
        let birthday = userSettingsClient.getBirthday()
        let life = Life(birthday: birthday, lifeExpectancy: lifeExpectancy)
        
        // Update the timeline entry
        let entry = LifeProgressEntry(life: life)
        let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
        completion(timeline)
    }
}

struct LifeProgressEntry: TimelineEntry {
    let date = Date()
    let life: Life
}

struct LifeProgressWidgetEntryView: View {

    @Environment(\.widgetFamily) var widgetFamily
    
    let entry: LifeProgressEntry

    var body: some View {
        let life = entry.life
        
        ZStack {
            SimplifiedLifeCalendarView(life: life)
            
            VStack {
                Text("\(life.formattedProgress)%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("**\(life.numberOfWeeksLeft)** weeks left")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .containerBackground(for: .widget) { }
    }
}

struct LifeProgressWidget: Widget {
    let kind: String = "LifeProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifeProgressProvider()) { entry in
            LifeProgressWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Life Progress")
        .description("Track your progress in life.")
    }
}

#Preview(as: .systemSmall) {
    LifeProgressWidget()
} timeline: {
    LifeProgressEntry(life: Life.mock)
}
