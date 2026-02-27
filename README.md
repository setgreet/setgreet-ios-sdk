# Setgreet iOS SDK

[![CocoaPods](https://img.shields.io/cocoapods/v/SetgreetSDK.svg?label=CocoaPods)](https://cocoapods.org/pods/SetgreetSDK)

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

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'SetgreetSDK', '~> 1.0.0'
```

## Usage

### Initialization

- Setgreet App Key: You can find your App Key at [Apps page](https://app.setgreet.com/apps).

Initialize the SDK in your AppDelegate / SceneDelegate or anywhere you want:

```swift
import UIKit
import SetgreetSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Setgreet.shared.initialize(
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
- `locale` (Optional): User's locale (e.g., "en-US"). If not provided, uses device's default locale

**Example:**

```swift
Setgreet.shared.identifyUser(
    userId: "user123",
    attributes: [
        "name": "John Doe",
        "email": "john@example.com",
        "plan": "premium"
    ],
    operation: .create,
    locale: "en-US"
)
```

### Reset User

Clears user identification data and resets user session state for logout scenarios. A new anonymous ID is generated after reset.

**Example:**

```swift
Setgreet.shared.resetUser()
```

### Anonymous ID

The SDK automatically generates an anonymous ID on initialization, which persists across app launches. When `identifyUser` is called, the anonymous identity is merged with the identified user. A new anonymous ID is generated when `resetUser()` is called.

```swift
let anonId = Setgreet.shared.anonymousId
```

### Show Flow

- Setgreet Flow ID: The flow ID is a unique identifier for the flow you want to show. You can get the flow ID from the flow's URL at the web app. For example, if the flow URL is `https://app.setgreet.com/flows/1234`, the flow ID is `1234`.

To show the Setgreet flow, call the following method:

```swift
Setgreet.shared.showFlow(flowId: "FLOW_ID")
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

## Flow Callbacks

Listen to flow lifecycle events to track user interactions and flow completion.

**Available Callbacks:**

- `onFlowStarted`: Called when a flow begins displaying
- `onFlowCompleted`: Called when user completes all screens in the flow
- `onFlowDismissed`: Called when user dismisses the flow before completion
- `onScreenChanged`: Called when user navigates between screens
- `onActionTriggered`: Called when user interacts with buttons
- `onPermissionRequested`: Called when a permission request completes
- `onError`: Called when an error occurs during flow operations

**Example:**

```swift
Setgreet.shared.setFlowCallbacks { callbacks in
    callbacks
        .onFlowStarted { event in
            print("Flow started: \(event.flowId)")
            print("Total screens: \(event.screenCount)")
        }
        .onFlowCompleted { event in
            print("Flow completed: \(event.flowId)")
            print("Duration: \(event.durationMs)ms")
        }
        .onFlowDismissed { event in
            print("Flow dismissed: \(event.flowId)")
            print("Reason: \(event.reason.rawValue)")
            print("Screen: \(event.screenIndex + 1)/\(event.screenCount)")
        }
        .onScreenChanged { event in
            print("Screen changed: \(event.fromIndex + 1) -> \(event.toIndex + 1)")
        }
        .onActionTriggered { event in
            print("Action: \(event.actionType)")
            if let name = event.actionName {
                print("Custom event name: \(name)")
            }
        }
        .onPermissionRequested { event in
            print("Permission \(event.permissionType): \(event.result)")
        }
        .onError { event in
            print("Error: \(event.errorType.rawValue) - \(event.message)")
        }
}
```

### Event Types

| Event                 | Description                      | Key Properties                    |
| --------------------- | -------------------------------- | --------------------------------- |
| `FlowStarted`         | Flow begins presenting           | `flowId`, `screenCount`           |
| `FlowCompleted`       | User completes the flow          | `flowId`, `durationMs`            |
| `FlowDismissed`       | Flow dismissed before completion | `flowId`, `reason`, `screenIndex` |
| `ScreenChanged`       | User navigates between screens   | `fromIndex`, `toIndex`            |
| `ActionTriggered`     | Button action triggered          | `actionType`, `actionName`        |
| `PermissionRequested` | Permission request completed     | `permissionType`, `result`        |
| `FlowError`           | Error during flow operations     | `errorType`, `message`            |

### Dismiss Reasons

| Reason         | Description                                 |
| -------------- | ------------------------------------------- |
| `userClose`    | User tapped the close button                |
| `userSkip`     | User tapped the skip button                 |
| `backPress`    | User pressed the back button (hardware)     |
| `swipeDown`    | User swiped down to dismiss                 |
| `replaced`     | Flow was replaced by a higher priority flow |
| `programmatic` | Flow was dismissed programmatically         |
| `completed`    | Flow reached its end node                   |

### Action Types

| Action                    | Description                     |
| ------------------------- | ------------------------------- |
| `next`                    | Navigate to next screen         |
| `previous`                | Navigate to previous screen     |
| `skip`                    | Skip the current screen         |
| `close`                   | Close/dismiss the flow          |
| `url`                     | Open a URL                      |
| `notification_permission` | Request notification permission |
| `location_permission`     | Request location permission     |
| `camera_permission`       | Request camera permission       |
| `request_review`          | Request app store review        |
| `share`                   | Open share sheet                |
| `open_settings`           | Open app settings               |

### Permission Types

| Type           | Description                  |
| -------------- | ---------------------------- |
| `notification` | Push notification permission |
| `location`     | Location access permission   |
| `camera`       | Camera access permission     |

### Permission Results

| Result               | Description                         |
| -------------------- | ----------------------------------- |
| `granted`            | Permission was granted by the user  |
| `denied`             | Permission was denied by the user   |
| `permanently_denied` | Permission was permanently denied   |
| `already_granted`    | Permission was already granted      |
| `not_required`       | Permission request was not required |

## Permissions Setup

If your flows use permission buttons, add the required keys to your `Info.plist`:

```xml
<!-- For location permission -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your description for location usage</string>

<!-- For camera permission -->
<key>NSCameraUsageDescription</key>
<string>Your description for camera usage</string>
```

Note: Notification permission doesn't require an Info.plist key.

## Configuration

### SetgreetConfig

```swift
SetgreetConfig(
    debugMode: Bool     // Enable debug logging (default: false)
)
```

### Operation Types

- `.create`: Create a new user record
- `.update`: Update an existing user record
