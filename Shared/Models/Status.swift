//
//  Status.swift
//  ECASChecker
//
//  Created by Roddy Munro on 02/04/2021.
//

import Foundation

struct Status: Codable, Equatable {
    let status: String
    var endpoint: String? = nil
    
    static func == (lhs: Status, rhs: Status) -> Bool {
        return lhs.status == rhs.status
    }
}
