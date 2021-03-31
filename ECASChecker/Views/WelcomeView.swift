//
//  WelcomeView.swift
//  ECASChecker
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let newFeatures: [NewFeature] = [
        NewFeature(iconName: "exclamationmark.triangle.fill", title: "Please Note", description: "This app was designed to be used for checking Family Sponsorship applications for Permanent Residency in Canada. Other application types are not compatible and will likely not work."),
        NewFeature(iconName: "lock.fill", title: "Data Privacy", description: "The information you submit in this app is not collected in any way and cannot be seen by anyone but yourself. When you submit your information, it is only used to get your application status from ECAS in this app. If you delete the app, your information will be wiped from your device."),
        NewFeature(iconName: "square.grid.3x3.topleft.fill", title: "Widget", description: "A widget is available as a part of this app. In order to use it, you must fill out your information inside the app first. Once set up, it will refresh automatically every 3 hours."),
        NewFeature(iconName: "star.fill", title: "Support the Developer", description: "Please consider leaving a positive review on the App Store. There is also the option to 'tip' the developer inside the app, though this is not mandatory, it is very much appreciated!"),
        NewFeature(iconName: "heart.fill", title: "Best of Luck", description: "Finally, I'd like to wish you the best of luck with your application. I've been through this process myself, and I hope this app will make it even the slightest bit easier for you.")
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: isIpad ? 64 : 32) {
                    Text("Thank You For Downloading").titleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.top, isIpad ? 80 : 32)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(newFeatures, content: NewFeatureRow.init)
                    }
                }
                .padding()
            }
            
            Button(action: { presentationMode.wrappedValue.dismiss() }, label: { Text("Continue") }).buttonStyle(PrimaryButtonStyle())
                .padding(.bottom, isIpad ? 64 : 32)
        }.padding(.horizontal, isIpad ? 128 : 24)
    }
}

struct NewFeatureRow: View {
    let feature: NewFeature
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: feature.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .foregroundColor(.accentColor)
                .padding(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title).headerStyle()
                Text(feature.description).foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
