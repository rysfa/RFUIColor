# RFUIColor

<!---
[![CI Status](https://img.shields.io/travis/rysfa/RFUIColor.svg?style=flat)](https://travis-ci.org/rysfa/RFUIColor)
[![Version](https://img.shields.io/cocoapods/v/RFUIColor.svg?style=flat)](https://cocoapods.org/pods/RFUIColor)
[![License](https://img.shields.io/cocoapods/l/RFUIColor.svg?style=flat)](https://cocoapods.org/pods/RFUIColor)
[![Platform](https://img.shields.io/cocoapods/p/RFUIColor.svg?style=flat)](https://cocoapods.org/pods/RFUIColor)
-->

A project that enhances the Objective-C and Swift built-in object, `UIColor`. It includes various extensions to `UIColor` handling blending, sorting, and various other commonly used color functionalities. As well as `NSString` for which it performs color conversions.

## Supports

- [x] Swift 5.0+
- [x] iOS 9.3.5+

## Features

- [x] Blend 2 colors, 3 colors, 4 colors, ..., at various different specified distributions.
- [x] Group an array of colors into specified color groups.
- [x] Sort an array of colors by brightness, hue, or by a specified array of colors.
- [x] Find the level of similarity/difference between 2 colors.
- [x] Given an array of colors, find the array element closest to a specified color.
- [x] Fetch the hue value, brightness value, and hexidecimal value of a color.
- [x] Fetch the color from a `NSString` value representing a hexidecimal value.
- [x] A wrapper library that handles downloading a list of colors and is easy to use with the extensions provided.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RFUIColor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RFUIColor'
```

## Author

rysfa, rfa1212@gmail.com

## License

RFUIColor is available under the MIT license. See the LICENSE file for more info.
