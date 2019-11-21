![SwiftSky](https://github.com/appcompany/SwiftSky/raw/assets/header.jpg)

[![License](https://img.shields.io/cocoapods/l/SwiftSky.svg)]()
[![Platform](https://img.shields.io/cocoapods/p/SwiftSky.svg)]()
[![Pod Version](https://img.shields.io/cocoapods/v/SwiftSky.svg)]()
[![Carthage compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager Compatible](https://img.shields.io/badge/swift--package--manager-compatible-brightgreen.svg)]()
[![Build Status](https://travis-ci.org/appcompany/SwiftSky.svg?branch=master)](https://travis-ci.org/appcompany/SwiftSky)
[![Documentation](https://appcompany.github.io/SwiftSky/badge.svg)](https://appcompany.github.io/SwiftSky)
[![Test Coverage](https://codecov.io/gh/appcompany/SwiftSky/branch/master/graph/badge.svg)](https://codecov.io/gh/appcompany/SwiftSky)
[![Apps Using SwiftSky](https://img.shields.io/cocoapods/at/SwiftSky.svg)]()
[![Twitter](https://img.shields.io/badge/twitter-@LucaSilverTweet-blue.svg?style=flat)](http://twitter.com/LucaSilverTweet)
[![Gitter](https://badges.gitter.im/SwiftSkyFramework/Lobby.svg)](https://gitter.im/SwiftSkyFramework/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


> SwiftSky let's you easily integrate the Dark Sky API into your Swift apps.

- [Requirements](#requirements)
- [Installation](#installation)
	- [CocoaPods](#cocoapods)
	- [Carthage](#carthage)
	- [Swift Package Manager](#swift-package-manager)
- [Usage](#usage)
	- [Setup](#setup)
	- [Settings](#settings)
	- [Requesting a Forecast](#requesting-a-forecast)
		- [Time Travel](#time-travel)
		- [The Forecast Object](#the-forecast-object)
- [Tests & Documentation](#tests--documentation)
- [Contribute](#contribute)
- [Consider Donating](#consider-donating)

## Requirements

- A Secret Key from [darksky.net/dev/register](https://darksky.net/dev/register)
- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.1+
- Swift 3.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build SwiftSky

To integrate SwiftSky into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

target '<Your Target Name>' do
    pod 'SwiftSky', '~> 1.3'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SwiftSky into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "AppCompany/SwiftSky" ~> 1.3
```

Run `carthage update` to build the framework and drag the built `SwiftSky.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but SwiftSky does support its use on supported platforms. 

Once you have your Swift package set up, adding SwiftSky as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/AppCompany/SwiftSky.git", majorVersion: 1)
]
```
## Usage

### Setup

First you must import SwiftSky everywhere you require to use it

```swift
import SwiftSky
```

Then before requesting any forecasts set the secret you got from [darksky.net/dev/register](https://darksky.net/dev/register)

```swift
SwiftSky.secret = "<DARKSKY_SECRET>"
```

### Settings

Optionally you can set the following settings as you wish (default values shown below)

```swift
SwiftSky.hourAmount = .fortyEight
        
SwiftSky.language = .english
    
SwiftSky.locale = .autoupdatingCurrent
    
SwiftSky.units.temperature = .fahrenheit
SwiftSky.units.distance = .mile
SwiftSky.units.speed = .milePerHour
SwiftSky.units.pressure = .millibar
SwiftSky.units.precipitation = .inch
SwiftSky.units.accumulation = .inch
```
For more details on these settings check the [documentation](https://appcompany.github.io/SwiftSky)

SwiftSky persists all your settings for you throughout a session. Simply set them once at app initialization and your good to go. You can change the settings anytime you want, though they will only be applied to new forecasts being requested.

### Requesting a Forecast

There is one simple but versatile function for requesting forecasts `SwiftSky.get()`. The function requires you to specify what data you want for which location. The below example displays all possible data types there are. The location accepts a `LocationConvertible` meaning you can pass it a `Location`, `CLLocation`, `CLLocationCoordinate2D` or a `String` formatted as such: `"<latitude>,<longitude>"`

```swift
SwiftSky.get([.current, .minutes, .hours, .days, .alerts],
    at: Location(latitude: 1.1234, longitude: 1.234)
) { result in
    switch result {
    case .success(let forecast):
        // do something with forecast
    case .failure(let error):
        // do something with error
    }
}
```

#### Time Travel

Time travel requests are also possible simple give the `SwiftSky.get` function a `Date` like so:

```swift
SwiftSky.get([.hours],
    at: Location(latitude: 1.1234, longitude: 1.234),
    on: Date(timeIntervalSince1970: 0)
) { result in
    // handle like a regular forecast call
}
```

#### The Forecast Object

The details of the `Forecast` object and all the data it contains can be found [here](https://appcompany.github.io/SwiftSky/Structs/DataPoint.html#/s:vV8SwiftSky9DataPoint4timeV10Foundation4Date)

## Tests & Documentation

[![Documentation](https://appcompany.github.io/SwiftSky/badge.svg)](https://appcompany.github.io/SwiftSky)
[![Test Coverage](https://codecov.io/gh/appcompany/SwiftSky/branch/master/graph/badge.svg)](https://codecov.io/gh/appcompany/SwiftSky)

This framework has been thoroughly tested and documented, as you can see by the badges above. A detailed description of the test coverage can be found [here](https://codecov.io/gh/appcompany/SwiftSky). The full documentation of SwiftSky can be found [here](https://appcompany.github.io/SwiftSky)

## Contribute

As with every open-source project, contributions are always welcome!

However, please follow these rules:
- Use the same style as is currently used
- Write the appropriate documentation for it
- Make sure everything is tested
- The code must be 100% open-source

## About

**SwiftSky** is developed and maintained by [Luca Silverentand](http://twitter.com/LucaSilverTweet), owner of

[![App Company.io](https://github.com/appcompany/SwiftSky/raw/assets/banner.png)](https://github.com/appcompany)

## Consider Donating

Are you using the framework and would like to see it being maintained and updated? Please consider helping me do exactly that by donating using the button below.

[<img alt="Donate" src="https://www.paypalobjects.com/webstatic/mktg/merchant_portal/button/donate.en.png" height="32px">](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9QSB8QX9QFM9Q "Donate")


