//
//  StatusDetailView.swift
//  ECASChecker
//
//  Created by Roddy Munro on 02/04/2021.
//

import SwiftUI

struct StatusDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    enum ActiveAlert { case error(_ error: ErrorModel) }
    
    let status: Status
    
    @State private var details: [String]?
    @State private var activeAlert: ActiveAlert?
    
    var body: some View {
        content
            .navigationTitle(status.status)
            .onAppear(perform: onAppear)
            .alert(using: $activeAlert) { alert in
                switch alert {
                    case .error(let error):
                        return Alert(
                            title: Text(error.title),
                            message: Text(error.message),
                            dismissButton: .default(Text("OK"), action: { presentationMode.wrappedValue.dismiss() })
                        )
                }
            }
    }
    
    var content: some View {
        Group {
            if let details = details {
                List {
                    ForEach(details.indices, id: \.self) { idx in
                        Text("\(idx+1). \(details[idx])")
                            .fontWeight(.medium)
                            .padding()
                    }
                }
            } else {
                ProgressView()
            }
        }
    }
    
    func onAppear() {
        if let endpoint = status.endpoint {
            EcasAPI.shared.getStatusDetail(from: endpoint) { result in
                switch result {
                    case .success(let details):
                        self.details = details
                    case .failure(let error):
                        self.activeAlert = .error(.init("Failed to Get Status", error))
                }
            }
        }
    }
}
