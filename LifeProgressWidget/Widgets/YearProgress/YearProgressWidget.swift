//
//  YearProgressWidget.swift
//  LifeProgressWidgetExtension
//
//  Created by Bartosz Król on 09/04/2023.
//

import Foundation

import WidgetKit
import SwiftUI
import Dependencies
import Combine

struct YearProgressProvider: TimelineProvider {
    
    let userSettingsClient = UserSettingsClient.liveValue
    
    func placeholder(in context: Context) -> YearProgressEntry {
        YearProgressEntry(life: Life.mock)
    }

    func getSnapshot(in context: Context, completion: @escaping (YearProgressEntry) -> ()) {
        // Get the user's data
        let lifeExpectancy = userSettingsClient.getLifeExpectancy()
        let birthday = userSettingsClient.getBirthday()
        let life = Life(birthday: birthday, lifeExpectancy: lifeExpectancy)
        // Update the timeline entry
        let entry = YearProgressEntry(life: life)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<YearProgressEntry>) -> ()) {
        // Get the user's data
        let lifeExpectancy = userSettingsClient.getLifeExpectancy()
        let birthday = userSettingsClient.getBirthday()
        let life = Life(birthday: birthday, lifeExpectancy: lifeExpectancy)
        
        // Update the timeline entry
        let entry = YearProgressEntry(life: life)
        let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
        completion(timeline)
    }
}

struct YearProgressEntry: TimelineEntry {
    let date = Date()
    let life: Life
}

struct YearProgressWidgetEntryView: View {

    @Environment(\.widgetFamily) var widgetFamily
    
    let entry: YearProgressEntry

    var body: some View {
        let life = entry.life
        
        ZStack {
            SimplifiedYearCalendarView(life: life)
            
            VStack(alignment: .center) {
                Text("\(life.formattedCurrentYearProgress)%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("**\(life.currentYearRemainingWeeks)** weeks until your birthday")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct YearProgressWidget: Widget {
    let kind: String = "YearProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: YearProgressProvider()) { entry in
            YearProgressWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Year Progress")
        .description("Track your progress in current year.")
    }
}

struct YearProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        let life = Life.mock
        let entry = YearProgressEntry(life: life)
        
        YearProgressWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
