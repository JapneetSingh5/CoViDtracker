//
//  CoViDtracker.swift
//  CoViDtracker
//
//  Created by Japneet Singh on /247/20.
//

import WidgetKit
import SwiftUI

struct Result: Codable {
    var Country : String
    var TotalConfirmed: Int
    var TotalRecovered: Int
    var TotalDeaths: Int
    var NewConfirmed: Int
    var NewRecovered: Int
    var NewDeaths: Int
    var CountryCode: String
    var Flag: String{
        let base : UInt32 = 127397
        var s = ""
        for v in CountryCode.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}

struct GlobalResponse: Codable {
    var Global: Result
}

let GlobalTest = Result(Country:"Global", TotalConfirmed: 15_802_607, TotalRecovered: 9_630_725, TotalDeaths: 639_215, NewConfirmed: 160_342, NewRecovered: 100_625, NewDeaths: 3_540, CountryCode: "GL")

struct GlobalSummaryWidget: View {
    var Global: Result
    @State private var isShowing = false
    
    var body: some View {
        VStack {
            Text("Global Summary").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("CONFIRMED").foregroundColor(.orange).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("\(Global.TotalConfirmed)")
            Text("↑ \(Global.NewConfirmed)").foregroundColor(.orange).fontWeight(.medium)
            Text("RECOVERED").foregroundColor(.green).fontWeight(.bold)
            Text("\(Global.TotalRecovered)")
            Text("↑ \(Global.NewRecovered)").foregroundColor(.green).fontWeight(.medium)
            Text("DECEASED").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("\(Global.TotalDeaths)")
            Text("↑ \(Global.NewDeaths)").foregroundColor(.red).fontWeight(.medium)
        }
    }
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        //
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        //
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        //
    }
    
    public typealias Entry = SimpleEntry
    var Global = GlobalTest

    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), Global: GlobalTest)
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, Global: GlobalTest)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    var Global: Result
}

struct PlaceholderView : View {
    var Global = GlobalTest
    var body: some View {
                VStack {
                    Text("Global Overview").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("CONFIRMED").foregroundColor(.orange).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(Global.TotalConfirmed)")
                    Text("↑ \(Global.NewConfirmed)").foregroundColor(.orange).fontWeight(.medium)
                    Text("RECOVERED").foregroundColor(.green).fontWeight(.bold)
                    Text("\(Global.TotalRecovered)")
                    Text("↑ \(Global.NewRecovered)").foregroundColor(.green).fontWeight(.medium)
                    Text("DECEASED").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(Global.TotalDeaths)")
                    Text("↑ \(Global.NewDeaths)").foregroundColor(.red).fontWeight(.medium)
                }

    }
}

struct CoViDtrackerEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family: WidgetFamily
    var Global : Result

    @ViewBuilder
        var body: some View {
            switch family {
            case .systemLarge: GlobalSummaryWidget(Global: Global)
            default: GlobalSummaryWidget(Global: Global)
            }
        }
}

struct GlobalStatusWidget: Widget {
    
    private let kind: String = "CoViDtracker"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: <#(Provider.Entry) -> _#>, placeholder: PlaceholderView()) { entry in
            CoViDtrackerEntryView(entry: entry, Global: GlobalTest)
        }
        .configurationDisplayName("Global Summary")
        .description("Track global coronavirus caseload from your homescreen.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}



@main
struct GameWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        GlobalStatusWidget()
    }
}
