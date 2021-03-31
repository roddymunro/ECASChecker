//
//  FormFields.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import SwiftUI

public struct FormField: View {
    private var label: String
    @Binding private var value: String
    private var placeholder: String?
    
    public init(_ label: String, value: Binding<String>, placeholder: String?=nil) {
        self.label = label
        self._value = value
    }
    
    public var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            TextField(label, text: $value)
                .multilineTextAlignment(.trailing)
        }
        .accessibility(identifier: "\(label.filter { !$0.isWhitespace })Label")
    }
}

public struct SecureFormField: View {
    private var label: String
    @Binding private var value: String
    
    public init(_ label: String, value: Binding<String>) {
        self.label = label
        self._value = value
    }
    
    public var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            SecureField(label, text: $value)
                .multilineTextAlignment(.trailing)
        }
        .accessibility(identifier: "\(label.filter { !$0.isWhitespace })Label")
    }
}
