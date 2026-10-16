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
pod 'SetgreetSDK', '~> LATEST_VERSION'
```

### Lottie animations (optional)

The core `SetgreetSDK` has no third-party dependencies. Lottie animation support is shipped as a separate, optional module — add it **only if your flows use Lottie animation components**. If you don't add it, `lottie` components in a flow render as empty and the rest of the flow is unaffected; the core SDK stays smaller and Lottie-free.

**Swift Package Manager** — add the `SetgreetSDKLottie` product, and (because SwiftPM binary frameworks can't declare their own dependencies) also add the Lottie package to your app target:

```swift
dependencies: [
    .package(url: "https://github.com/setgreet/setgreet-ios-sdk.git", .upToNextMajor(from: "LATEST_VERSION")),
    .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.6.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "SetgreetSDK", package: "setgreet-ios-sdk"),
            .product(name: "SetgreetSDKLottie", package: "setgreet-ios-sdk"),
            .product(name: "Lottie", package: "lottie-spm")
        ]
    )
]
```

**CocoaPods** — add the companion pod (it pulls in `lottie-ios` automatically):

```ruby
pod 'SetgreetSDK', '~> LATEST_VERSION'
pod 'SetgreetSDKLottie', '~> LATEST_VERSION'
```

**Register at startup** — call this once before the first Setgreet flow is shown (e.g. in your `AppDelegate` / `App.init()`):

```swift
import SetgreetSDKLottie

SetgreetLottie.register()
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
- `onActionTriggered`: Called when a button's action is triggered, just before it runs, so it arrives even when the action closes the flow, and even when required inputs on the screen then stop the action (see [Action Types](#action-types))
- `onCustomAction`: Called when user taps a button whose action is Custom, with that action's data
- `onTrackEvent`: Called when a button's Track Event action runs, with the event name and properties
- `onPermissionRequested`: Called when a permission request completes
- `onPurchaseCompleted`, `onPurchaseCancelled`, `onPurchaseFailed`, `onPurchasePending`, `onRestoreCompleted`, `onRestoreFailed`: Called with the outcome of a paywall's purchase and restore buttons (see [Purchases and Paywalls](#purchases-and-paywalls))
- `onError`: Called when a flow the SDK set out to show could not be shown (see [Flow Errors](#flow-errors))

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
            print("Reason: \(event.reason)")
            print("Screen: \(event.screenIndex + 1)/\(event.screenCount)")
        }
        .onScreenChanged { event in
            print("Screen changed: \(event.fromIndex + 1) -> \(event.toIndex + 1)")
        }
        .onActionTriggered { event in
            print("Action: \(event.actionType) on screen \(event.screenIndex + 1)")
        }
        .onCustomAction { event in
            print("Custom action: \(event.data ?? [:])")
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

| Event                 | Description                               | Key Properties                            |
| --------------------- | ----------------------------------------- | ----------------------------------------- |
| `FlowStarted`         | Flow begins presenting                    | `flowId`, `screenCount`                   |
| `FlowCompleted`       | User completes the flow                   | `flowId`, `durationMs`                    |
| `FlowDismissed`       | Flow dismissed before completion          | `flowId`, `reason`, `screenIndex`         |
| `ScreenChanged`       | User navigates between screens            | `fromIndex`, `toIndex`                    |
| `ActionTriggered`     | Button action ran (before its effect)     | `actionType`, `actionName`, `screenIndex` |
| `CustomAction`        | Custom button action tapped               | `flowId`, `data`, `screenIndex`           |
| `TrackEvent`          | Track Event button action ran             | `eventName`, `properties`                 |
| `PermissionRequested` | Permission request completed              | `permissionType`, `result`                |
| `FlowError`           | A flow failed to fetch, decode or present | `flowId`, `errorType`, `message`          |

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

`actionType` is one of these values, the same on every Setgreet SDK. `event.action` gives it as a `SetgreetActionType`. A `back` action reports `previous`, and a `close` action reports `dismiss`.

| Action                             | Description                                        |
| ---------------------------------- | -------------------------------------------------- |
| `next`                             | Navigate to next screen                            |
| `previous`                         | Navigate to previous screen                        |
| `skip`                             | Skip the flow                                      |
| `dismiss`                          | Close the flow                                     |
| `url`                              | Open a URL                                         |
| `request_notification_permission`  | Request notification permission                    |
| `request_location_permission`      | Request location permission                        |
| `request_camera_permission`        | Request camera permission                          |
| `request_tracking_permission`      | Request App Tracking Transparency                  |
| `request_microphone_permission`    | Request microphone permission                      |
| `request_photo_library_permission` | Request photo library permission                   |
| `request_review`                   | Request an App Store review                        |
| `share`                            | Open the share sheet                               |
| `open_settings`                    | Open app settings                                  |
| `track_event`                      | Track an event; `actionName` is the event name     |
| `custom`                           | Custom action (also delivered to `onCustomAction`) |
| `purchase`                         | Purchase through your purchase provider            |
| `restore_purchases`                | Restore purchases through your purchase provider   |

`actionName` is set only for `track_event`. An action that does nothing is not reported: an unknown action type, a `url` action with no target, or a purchase or restore button without its action. Auto-advance and option selection are not button actions.

### Flow Errors

`onError` fires when a flow the SDK set out to show does not show:

| `errorType` | When                                                            |
| ----------- | --------------------------------------------------------------- |
| `network`   | The request failed, or the server answered with an error status |
| `parse`     | The response could not be decoded, or carried no flow           |
| `display`   | The flow could not be presented, or had no screen to render     |
| `unknown`   | Anything else                                                   |

It covers `showFlow(flowId:)`, a flow returned by `trackEvent`, `trackScreen` or `identifyUser` that cannot be decoded or presented, and the presentation of every flow. A `trackEvent`, `trackScreen` or `identifyUser` request that fails before any response is only logged, because no flow is known to have matched. `flowId` is empty when the SDK never learned it. Purchase and restore failures have their own callbacks.

### Permission Types

| Type           | Description                  |
| -------------- | ---------------------------- |
| `notification` | Push notification permission |
| `location`     | Location access permission   |
| `camera`       | Camera access permission     |
| `tracking`     | App Tracking Transparency    |
| `microphone`   | Microphone access permission |
| `photoLibrary` | Photo library access         |

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

<!-- For tracking permission (App Tracking Transparency) -->
<key>NSUserTrackingUsageDescription</key>
<string>Your description for tracking</string>

<!-- For microphone permission -->
<key>NSMicrophoneUsageDescription</key>
<string>Your description for microphone usage</string>

<!-- For photo library permission -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Your description for photo library access</string>
```

Note: Notification permission doesn't require an Info.plist key. If a key is missing, the SDK reports `not_required` for that button instead of asking.

## Purchases and Paywalls

A paywall screen built in Setgreet sells through the purchase tool your app already uses, such as RevenueCat or StoreKit 2. Setgreet does not wrap that tool and never needs its API key: you implement `SetgreetPurchaseProvider` on top of it, then register it once, after configuring your tool and initializing Setgreet:

```swift
Setgreet.shared.setPurchaseProvider(MyPurchaseProvider())

// Or read a specific offering when a paywall names no source:
Setgreet.shared.setPurchaseProvider(MyPurchaseProvider(), defaultSource: .offering("onboarding"))
```

| Member                         | Purpose                                                                             |
| ------------------------------ | ----------------------------------------------------------------------------------- |
| `providerId`                   | A short name for your tool, such as `revenuecat`                                    |
| `loadProducts(_:)`             | Returns the products of a source (the current offering, an offering or a placement) |
| `purchase(productRef:source:)` | Buys a product: `purchased`, `cancelled`, `pending` or `failed`                     |
| `restorePurchases()`           | Restores purchases: `restored`, `nothingToRestore` or `failed`                      |
| `accessState()`                | What the user already has access to, or `nil` when your tool cannot say             |
| `trackPaywallImpression(_:)`   | Forwards a paywall view to your tool                                                |
| `setAttributes(_:)`            | Forwards user attributes to your tool                                               |
| `identify(userId:)`, `reset()` | Optional: keep your tool's user in step with Setgreet                               |

The paywall branches the flow on the outcome, and the purchase callbacks above report it to your app. The full guide, with a RevenueCat provider ready to copy, is at [setgreet.com/docs/sdk/purchases](https://setgreet.com/docs/sdk/purchases).

## Configuration

### SetgreetConfig

```swift
SetgreetConfig(
    debugMode: Bool     // Enable debug logging
)
```

### Operation Types

- `.create`: Create a new user record
- `.update`: Update an existing user record

## External Data in Flows

Flows can render data fetched from **your own** API — a product list filtered by answers the user gave earlier in the same flow. You register the endpoint once in the Setgreet dashboard (Data Sources), bind it into a screen, and it renders.

**Nothing to add to your app.** The SDK resolves a data-bound screen as the user enters it. There is no new API to call, no new permission and no new dependency.

What is worth knowing:

- **Setgreet calls your API from its servers, not from the device**, so your endpoint must be reachable over HTTPS from the public internet. Setgreet signs each request and asserts the end user's id; verify the signature on your side.
- **A failure degrades, it does not blank.** If your API is slow or down, the screen renders without the data-bound parts. Only if the flow author explicitly chose "skip screen" is it passed over.
- **Answers reach your API by input name.** An input named `goal` in the editor arrives as `goal`. Attributes you set via `identifyUser` are available to it too.

See [External Data](https://setgreet.com/docs/personalization/external-data) for the endpoint contract and the signature-verification recipe.
