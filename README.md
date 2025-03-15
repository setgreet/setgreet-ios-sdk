# Setgreet iOS SDK

Setgreet iOS SDK allows you to show Setgreet flows in your iOS app.

## Requirements
- iOS 15.0 and above

## Installation
### Swift Package Manager
You can add Setgreet to your project using Swift Package Manager. Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/setgreet/setgreet-ios-sdk.git", .upToNextMajor(from: "LATEST_VERSION"))
]
```

Or you can add it directly within Xcode:
1. Open your project in Xcode.
2. Go to `File` > `Add Packages`.
3. Enter the URL: `https://github.com/setgreet/setgreet-ios-sdk.git`.
4. Select the version rule and click `Add Package`.

## Usage

### Initialization
- Setgreet App Key: You can get the app key while creating a new app in the Setgreet flow editor.

Initialize the SDK in your AppDelegate or SceneDelegate:

```Swift
import UIKit
import Setgreet

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Setgreet.initialize(
            appKey: "APP_KEY",
            config: SetgreetConfig(
                debugMode: false
            )
        )
        
        return true
    }
}
```

### Show Flow
- Setgreet Flow ID: The flow ID is a unique identifier for the flow you want to show. You can get the flow ID from the flow's URL at the web app. For example, if the flow URL is `https://app.setgreet.com/flows/1234`, the flow ID is `1234`.

To show the Setgreet flow, call the following method:

```Swift
Setgreet.showFlow(flowId = "FLOW_ID")
```
