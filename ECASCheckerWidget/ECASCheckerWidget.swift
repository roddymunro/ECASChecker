//
//  ECASCheckerWidget.swift
//  ECASCheckerWidget
//
//  Created by Roddy Munro on 29/03/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let ud = UserDefaults(suiteName: "group.com.roddy.io.ECASChecker")
    let dummyStatus = ApplicationStatus(name: "Roddy Munro", sponsorStatus: "In Process", prStatus: "In Process")
    let failedStatus = ApplicationStatus(name: "", sponsorStatus: "Not Available", prStatus: "Not Available")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), status: .success(dummyStatus))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), status: .success(dummyStatus))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        guard let idType = ud?.string(forKey: "idType"),
            let idNumber = ud?.string(forKey: "idNumber"),
            let lastName = ud?.string(forKey: "lastName"),
            let birthDate = ud?.string(forKey: "birthDate"),
            let country = ud?.string(forKey: "country") else {
            completion(Timeline(entries: [.init(date: Date(), status: .failure(StatusError.noValuesSet))], policy: .atEnd))
            return
        }
        
        EcasAPI.shared.getStatus(idType: idType, idNum: idNumber, lastName: lastName, birthDate: birthDate, country: country) { status in
            entries.append(.init(date: Date(), status: status))
            let currentDate = Date()
            let expiryDate = Calendar.current.date(byAdding: .hour, value: 3, to: currentDate) ?? Date()
            let timeline = Timeline(entries: entries, policy: .after(expiryDate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let status: Result<ApplicationStatus, Error>
}

struct ECASCheckerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Group {
            switch entry.status {
                case .success(let status):
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Sponsor Status").font(Font.caption.weight(.semibold)).foregroundColor(.secondary)
                            Text(status.sponsorStatus).font(Font.body.weight(.medium))
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            Text("PR Status").font(Font.caption.weight(.semibold)).foregroundColor(.secondary)
                            Text(status.prStatus).font(Font.body.weight(.medium))
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                case .failure(let error):
                    Text("Error fetching status: \(error.localizedDescription)")
                        .font(Font.caption)
            }
        }.padding()
    }
}

@main
struct ECASCheckerWidget: Widget {
    let kind: String = "ECASCheckerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ECASCheckerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ECAS Widget")
        .description("This widget will get your latest status from ECAS every hour.")
        .supportedFamilies([.systemSmall])
    }
}
