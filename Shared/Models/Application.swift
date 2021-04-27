//
//  Application.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation

struct Application: Codable, Equatable {
    let name: String
    let sponsorStatus: Status
    let prStatus: Status
    
    static func == (lhs: Application, rhs: Application) -> Bool {
        lhs.name == rhs.name && lhs.sponsorStatus == rhs.sponsorStatus && lhs.prStatus == rhs.prStatus
    }
}
