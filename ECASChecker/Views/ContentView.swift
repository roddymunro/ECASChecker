//
//  ContentView.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    enum ActiveAlert { case error(_ error: ErrorModel), thankYou }
    enum ActiveSheet { case welcome }
    
    static let ud = UserDefaults(suiteName: "group.com.roddy.io.ECASChecker")
    
    @AppStorage("welcomeShown") var welcomeShown: Bool = false
    @AppStorage("idType", store: ud) var idType: String = ""
    @AppStorage("idNumber", store: ud) var idNumber: String = ""
    @AppStorage("lastName", store: ud) var lastName: String = ""
    @AppStorage("birthDate", store: ud) var birthDate: Date = Date()
    @AppStorage("country", store: ud) var country: String = ""
    
    @State private var appStatus: ApplicationStatus?
    @State private var activeAlert: ActiveAlert?
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("ECAS Checker")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: onAppear)
        .alert(using: $activeAlert) { alert in
            switch alert {
                case .error(let error):
                    return Alert(title: Text(error.title), message: Text(error.message))
                case .thankYou:
                    return Alert(title: Text("Thank you for the tip!"))
            }
        }
        .sheet(using: $activeSheet) { sheet in
            switch sheet {
                case .welcome:
                    WelcomeView()
            }
        }
    }
    
    var content: some View {
        Form {
            Section(header: Text("Sponsor/Applicant Information")) {
                Picker(selection: $idType, label: Text("ID Type").fontWeight(.medium)) {
                    ForEach(IdentificationType.all) { idType in
                        Text(idType.name).tag(idType.id)
                    }
                }
                SecureFormField("ID Number", value: $idNumber)
                FormField("Last Name", value: $lastName)
                DatePicker(selection: $birthDate, displayedComponents: .date) {
                    Text("Birth Date").fontWeight(.medium)
                }
                    
                Picker(selection: $country, label: Text("Country").fontWeight(.medium)) {
                    ForEach(Country.all) { country in
                        Text(country.name).tag(country.id)
                    }
                }
                Button("Get Status", action: getStatus)
                    .font(Font.body.weight(.bold))
            }
            
            if let status = appStatus {
                Section(header: Text("Application Status")) {
                    Text("Name: \(status.name)")
                    Text("Sponsor Status: \(status.sponsorStatus)")
                    Text("PR Status: \(status.prStatus)")
                }
            }
            
            Section(header: Text("More Info")) {
                Button(action: tipDeveloper, label: { Label("Tip Developer", systemImage: "heart.fill")})
                Button(action: openTwitter, label: { Label("Contact Developer", systemImage: "envelope.fill") })
                Button(action: { activeSheet = .welcome }, label: { Label("Show Welcome Message", systemImage: "note") })
            }
        }
    }
    
    private func getStatus() {
        endEditing(true)
        EcasAPI.shared.getStatus(idType: idType, idNum: idNumber, lastName: lastName, birthDate: Self.dateFormatter.string(from: birthDate), country: country) { result in
            switch result {
                case .success(let status):
                    self.appStatus = status
                case .failure(let error):
                    self.activeAlert = .error(.init("Failed to Get Status", error))
            }
        }
    }
    
    private func openTwitter() {
        UIApplication.shared.open(URL(string: "https://www.twitter.com/podomunro")!, options: [:])
    }
    
    private func onAppear() {
        if !welcomeShown {
            welcomeShown = true
            activeSheet = .welcome
        }
    }
    
    private func tipDeveloper() {
        UIApplication.shared.open(URL(string: "https://www.paypal.com/paypalme/roddym23")!, options: [:])
    }
}


private extension ContentView {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
}
