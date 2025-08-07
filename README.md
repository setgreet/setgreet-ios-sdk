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

### Identify User

Identifies a user for Setgreet analytics and flow management.

**Parameters:**

- `userId` (String): The unique identifier for the user
- `attributes` (Optional): Additional user attributes
- `operation` (Optional): The operation type for user attributes (CREATE or UPDATE)

**Example:**

```swift
Setgreet.shared.identifyUser(
    userId: "user123",
    attributes: [
        "name": "John Doe",
        "email": "john@example.com",
        "plan": "premium"
    ],
    operation: .create
)
```

### Reset User

Clears user identification data and resets user session state for logout scenarios.

**Example:**

```swift
Setgreet.shared.resetUser()
```

### Show Flow
- Setgreet Flow ID: The flow ID is a unique identifier for the flow you want to show. You can get the flow ID from the flow's URL at the web app. For example, if the flow URL is `https://app.setgreet.com/flows/1234`, the flow ID is `1234`.

To show the Setgreet flow, call the following method:

```Swift
Setgreet.shared.showFlow(flowId = "FLOW_ID")
```

### Track Screen

Tracks a screen view for analytics and potential flow triggers.

**Parameters:**

- `screenName` (String): The name of the screen being viewed
- `properties` (Optional): Additional properties associated with the screen view

**Example:**

```swift
Setgreet.shared.trackScreen(
    screenName: "product_detail",
    properties: [
        "product_id": "prod_123",
        "category": "electronics",
        "price": 299.99
    ]
)
```

### Track Event

Tracks custom events for analytics and flow triggers.

**Parameters:**

- `eventName` (String): The name of the custom event
- `properties` (Optional): Additional properties associated with the event

**Example:**

```swift
Setgreet.shared.trackEvent(
    eventName: "purchase_completed",
    properties: [
        "order_id": "ord_456",
        "total_amount": 299.99,
        "payment_method": "credit_card",
        "items_count": 3
    ]
)
```
