# Zipz SDK for iOS
This open-source library allows you to integrate Zipz into your own iOS app.



## Installation

### Manually

At the moment the only way to install Zipz SDK. Clone or download [framework](https://github.com/Zipz-App/zipz-sdk-ios). 

- Open the new `zipz-sdk-ios-master` folder, and drag the `ZipzSDK.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. 

- Select the `ZipzSDK.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see `ZipzSDK.framework` nested inside a `Products` folder. Select `ZipzSDK.framework`

- And that's it!

  > The `ZipzSDK.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Zipz SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
   Coming soon...
```

### Add Zipz App ID and App Secret

To make the SDK identifiable by Zipz servers, the host app must add `APP_ID` and `APP_SECRET` keys to your project's `Info.plist` file: 

```xml
    <key>APP_ID</key>
    <string>YOUR_APP_ID_STRING</string>
    <key>APP_SECRET</key>
    <string>YOUR_APP_SECRET_STRING</string>
```
By adding those two keys you are now ready to use Zipz SDK framework.



## Requests/Interactions

For all interactions between the Host App and Zipz SDK, the user requesting the data must be identified. Zipz provides a `uuid` for each user registered on its database.

