# YesGraph iOS SDK

[![Travis](https://travis-ci.org/YesGraph/ios-sdk.svg)](https://travis-ci.org/YesGraph/ios-sdk)
[![CocoaPods](https://img.shields.io/cocoapods/v/YesGraph-iOS-SDK.svg?style=flat)](http://cocoapods.org/?q=)
[![Coverage Status](https://coveralls.io/repos/YesGraph/ios-sdk/badge.svg?branch=develop&service=github)](https://coveralls.io/github/YesGraph/ios-sdk?branch=develop)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod Version](http://img.shields.io/cocoapods/v/YesGraph-iOS-SDK.svg?style=flat)](http://cocoadocs.org/docsets/YesGraph-iOS-SDK/)
[![Pod Platform](http://img.shields.io/cocoapods/p/YesGraph-iOS-SDK.svg?style=flat)](http://cocoadocs.org/docsets/YesGraph-iOS-SDK/)
[![Pod License](http://img.shields.io/cocoapods/l/YesGraph-iOS-SDK.svg?style=flat)](http://opensource.org/licenses/MIT)

YesGraph iOS SDK is a sharing iOS SDK that integrates with YesGraph. It presents user with a share sheet that can be used to share a message to user's friends to multiple sources, such as: Facebook, Twitter or user's contact book. [Read more about that on our blog.](http://blog.yesgraph.com/perfect-share-flow/) 

Find detailed documentation about YesGraph on [yesgraph.com](https://docs.yesgraph.com)

## Requirements

The SDK is compatible with iOS apps with iOS 8 and above. It requires Xcode 7.x and iOS 9.x SDK to build the source.

## Integration

The easiest way to integrate is with **CocoaPods**. Add the following Pod to your **Podfile**:

```
pod 'YesGraph-iOS-SDK'
```

An alternate way to integrate is using **Carthage**. Add the following link to your **CartFile**:

```
github "YesGraph/ios-sdk"
```

Or integrate it manually by drag & dropping all **.h** and **.m** files from YesGraphSDK folder into your project.
You must also import the library by either:

*Objective-C*
```objective-c
#import <YesGraphSDK/YesGraphSDK.h>

@import YesGraphSDK; // Only if using modules
```
*Swift*
```swift
import YesGraphSDK
```

# Example applications

There are 3 example applications included in the repository, that display the share sheet when triggered. All examples are the same, but they contain different ways of SDK integration.

- Example - Is a **Objective-C** app that includes YesGraphSDK as a framework and uses it as a module.
- Example-Static - Is a **Objective-C** app that includes YesGraph SDK as a static library.
- Example-Swift - Is a **Swift** app that includes YesGraphSDK as a framework.

## Getting Started with Example applications

**Like YesGraph SDK, all example apps require Xcode 7.x to build and run.**

Before you can use any of the example apps, you need to configure the app with your **YesGraph client key**. Because YesGraph treats mobile devices as untrusted clients, first you need a trusted backend to generate client keys.

[Read more about connecting apps](https://docs.yesgraph.com/docs/connecting-apps#mobile-apps)
[Read more about creating client keys](https://docs.yesgraph.com/docs/create-client-keys)

1. If you haven't already, sign up for a YesGraph account (it takes seconds). Then go to YesGraph Dashboard: https://www.yesgraph.com/apps/.
2. Copy the live secret key on the bottom of the page to your trusted backend.
3. Call your trusted backend with user ID, to get the client key back (you can generate a random user ID, if user is not known, by using `YSGUtility` class and `randomUserId` method.
4. Configure YesGraph iOS SDK with received **client key** and **user ID**:

   *Objective-C*
   ```objective-c
   [[YesGraph shared] configureWithClientKey:clientKey];
   [[YesGraph shared] configureWithUserId:userId];
   ```
   
   *Swift*
   ```swift
   YesGraph.shared().configureWithClientKey(clientKey)
   YesGraph.shared().configureWithUserId(userId)
   ```
5. Run the desired Example app.

## Tests

YesGraph iOS SDK contains unit tests that can be executed in Xcode.

- Open **YesGraph/YesGraphSDK.xcworkspace**
- Choose the "YesGraphSDK" scheme
- Run Product -> Test

License
======

YesGraph iOS SDK is released under **MIT** license. See [LICENSE](https://github.com/YesGraph/ios-sdk/blob/master/LICENSE) file for more information.
