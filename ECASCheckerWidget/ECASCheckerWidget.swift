//
//  ECASCheckerWidget.swift
//  ECASCheckerWidget
//
//  Created by Roddy Munro on 29/03/2021.
//

import WidgetKit
import SwiftUI
import UserNotifications

struct Provider: TimelineProvider {
    
    let ud = UserDefaults(suiteName: "group.com.roddy.io.ECASChecker")
    let dummyStatus = Application(name: "Roddy Munro", sponsorStatus: .init(status: "In Process"), prStatus: .init(status: "In Process"))
    let failedStatus = Application(name: "", sponsorStatus: .init(status: "Not Available"), prStatus: .init(status: "Not Available"))
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), status: .success(dummyStatus))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), status: .success(dummyStatus))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        var previousApplication: Application?
        if let savedApplication = ud?.object(forKey: "prevApp") as? Data {
            let decoder = JSONDecoder()
            if let loadedApp = try? decoder.decode(Application.self, from: savedApplication) {
                previousApplication = loadedApp
            }
        }
        
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
            let expiryDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate) ?? Date()
            let timeline = Timeline(entries: entries, policy: .after(expiryDate))
            
            if case .success(let application) = status {
                self.compareStatus(previousApplication, application)
            }
            
            completion(timeline)
        }
    }
    
    func compareStatus(_ oldStatus: Application?, _ newStatus: Application) {
        if let oldStatus = oldStatus, oldStatus != newStatus {
            let content = UNMutableNotificationContent()
            content.title = "Application Status Update"
            content.body = "It appears there is an update to your application. Open the app to find out more."
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let status: Result<Application, Error>
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
                            Text(status.sponsorStatus.status).font(Font.body.weight(.medium))
                                .minimumScaleFactor(0.6)
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            Text("PR Status").font(Font.caption.weight(.semibold)).foregroundColor(.secondary)
                            Text(status.prStatus.status).font(Font.body.weight(.medium))
                                .minimumScaleFactor(0.6)
                        }
                        Divider()
                        HStack(spacing: 2) {
                            Text(entry.date, style: .relative)
                                .font(.caption2)
                                .multilineTextAlignment(.trailing)
                            Text("ago")
                                .font(.caption2)
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
