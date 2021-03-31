//
//  Text+ViewModifier.swift
//  ECASChecker
//

import SwiftUI

extension Text {
    func titleStyle() -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
    }
    
    func captionStyle() -> some View {
        self
            .font(.caption)
    }
    
    func formLabelStyle() -> some View {
        self
            .fontWeight(.medium)
    }
    
    func headerStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
    }
    
    func toolbarStyle() -> some View {
        self
            .fontWeight(.medium)
    }
}
