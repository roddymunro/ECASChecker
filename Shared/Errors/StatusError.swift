//
//  StatusError.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation

enum StatusError: Error {
    case noValuesSet
    case failedRequest
    case parsingError
}

extension StatusError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noValuesSet:
            return NSLocalizedString(
                "One or more required fields are missing. Please open the app and set the fields.",
                comment: ""
            )
        case .failedRequest:
            return NSLocalizedString(
                "Request failed. Please check your internet connection and try again.",
                comment: ""
            )
        case .parsingError:
            return NSLocalizedString(
                "Failed to get application status. Please double check your information and try again.",
                comment: ""
            )
        }
    }
}
