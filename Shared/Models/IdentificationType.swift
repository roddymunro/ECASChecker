//
//  IdentificationType.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation

struct IdentificationType: Identifiable {
    let id: String
    let name: String
}

extension IdentificationType {
    static let all: [IdentificationType] = [
        .init(id: "1", name: "Client ID Number / Unique Client Identifier"),
        .init(id: "2", name: "Receipt Number (IMM 5401)"),
        .init(id: "3", name: "Application Number / Case Number"),
        .init(id: "4", name: "Record of Landing Number"),
        .init(id: "5", name: "Permanent Resident Card Number"),
        .init(id: "6", name: "Citizenship Receipt Number"),
        .init(id: "7", name: "Citizenship File Number / Group Number"),
        .init(id: "8", name: "Confirmation of Permanent Residence Number")
    ]
}
