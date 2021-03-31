//
//  Date+Ext.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation

extension Date: RawRepresentable {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    public var rawValue: String {
        Date.dateFormatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.dateFormatter.date(from: rawValue) ?? Date()
    }
}
