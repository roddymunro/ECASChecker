//
//  ErrorModel.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation

struct ErrorModel: Identifiable {
    public var id = UUID()
    private(set) var title: String
    private var error: Error
    
    var message: String {
        error.localizedDescription
    }
    
    init(_ title: String, _ error: Error) {
        self.title = title
        self.error = error
    }
}
