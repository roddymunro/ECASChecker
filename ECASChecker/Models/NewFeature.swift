//
//  NewFeature.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation

struct NewFeature: Identifiable {
    let id = UUID().uuidString
    let iconName: String
    let title: String
    let description: String
}
