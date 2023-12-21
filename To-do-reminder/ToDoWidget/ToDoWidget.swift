//
//  ToDoWidget.swift
//  ToDoWidget
//
//  Created by TanjilaNur-00115 on 14/9/23.
//

import WidgetKit
import SwiftUI
import Intents


///Time Line Provider
struct Provider: IntentTimelineProvider {
    
    ///Placeholder to show static data to user
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    text: "Placeholder",
                    configuration: ConfigurationIntent())
    }

    ///Snapshot to use a preview when adding widgets
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                text: "Sanpshot",
                                configuration: configuration)
        completion(entry)
    }

    /// This function refreshes the widget for events
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Retrieve text from UserDefaults
        let userDefaults = UserDefaults(suiteName: "group.widgetcache")
        let text = userDefaults?.value(forKey: "toDoItem") as? String ?? "Nothing to do!"
        print(text)

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

///SimpleEntry Model
struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let configuration: ConfigurationIntent
}

///ToDo WidgetEntry View
struct ToDoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .clipped()
            }
            
            Text(entry.text)
                .font(Font.system(size: 24, weight: .semibold, design: .default))
                .foregroundColor(.white)
        }
    }
}

///ToDo Widget
struct ToDoWidget: Widget {
    let kind: String = "ToDoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ToDoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ToDo Widget")
        .description("This is a task reminder widget.")
    }
}

///ToDoWidget_Previews
struct ToDoWidget_Previews: PreviewProvider {
    static var previews: some View {
        ToDoWidgetEntryView(entry: SimpleEntry(date: Date(),
                                               text: "Nothing to Do!",
                                               configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

