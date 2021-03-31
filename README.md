# ECASChecker
A simple iOS app for checking your Canadian Permanent Residency application status. This project includes an iOS app and a widget, both created using SwiftUI.

This app was originally intended for the App Store, however it was rejected, so the next best thing was to open source it so that others could make use of it.

If this app is useful to you, I'd appreciate a shoutout on [Twitter](https://www.twitter.com/podomunro), or you can [tip me](https://www.paypal.com/paypalme/roddym23).

## Contributions

Please feel free to open a pull request and extend the app. It is not guaranteed that this will work for all ECAS applications - as an applicant for Permanent Residency via the Family Sponsorship route, I am only able to test using my own application!

![A screenshot of the ECAS Checker app](https://mypublicbucket-podomunro.s3.us-east-2.amazonaws.com/github/ecaschecker_readme.jpeg)

## Tech Stack
- SwiftUI
- WidgetKit
- [SwiftSoup](https://github.com/scinfu/SwiftSoup)

## Setup

### Prerequisites
- A Mac running at least macOS Big Sur (I haven't tried on previous versions)
- An Apple Developer account
- Xcode 12.4 or newer
- Knowledge of modifying and running Xcode projects
- An active Canadian Permanent Residency application that is accessible through [ECAS](https://services3.cic.gc.ca/ecas/security.do?app=ecas&lang=en)

### Steps
1. Clone this repository to your local machine: `git clone https://github.com/roddymunro/ECASChecker.git`
2. Open the project in Xcode
3. Update any App Signing teams and Bundle IDs for both the iOS app and Widget
4. Open [developer.apple.com](https://developer.apple.com), sign in and click on 'Certificates, Identifiers & Profiles'
5. Click on 'Identifiers' on the left hand side, then click the '+' button
6. Select App groups, click 'Continue' and then enter a unique App Group ID
7. Back in Xcode, for both the ECASChecker and ECASCheckerWidget targets, click on 'Signing and Capabilities', and then under 'App Groups', select your new App Group
8. Inside `ECASChecker/Views/ContentView.swift`, on line 16, update the UserDefaults suite name to your new App Group
9. Inside `ECASCheckerWidget/ECASCheckerWidget.swift`, on line 13, update the UserDefaults suite name to your new App Group
10. Build and run the app. The iOS app should load, and if you enter your PR application details, your status should be returned. This information will be kept in UserDefaults on your device so you can quickly check your application in the future.
11. On your device, you can also add the ECASChecker widget. In order for this to work, you need to have entered your details inside the app first. The widget will refresh every 3 hours, though you can reduce this inside the widget's code.
