# DefaultApp README

## DefaultApp is an open source starting point – a template - for native macOS developers.

I maintained it in Objective-C for over a decade before finally porting it to Swift in 2018. Anytime I start a new app – big or small, whether or not it’s something I plan on releasing publicly or if it’s just a small prototype or utility app I’m building for myself – I start with this project.

## What's Included

* It builds a native macOS app targeting 10.14 Mojave and 10.15 Catalina.
* A hardened-runtime target ready for Notarization and designed to be distributed directly to your customers.
* A second, duplicate target that is Sandboxed and ready for distribution via the Mac App Store.
* Conditional build flags that let you differentiate between debug and production builds as well as Mac App Store and direct to consumer builds.
* It also builds an iOS companion app target for iOS 13 with shared code between the two platforms.
* Default `NSWindowController`s for a primary app window and Preferences window are wired up and ready to go. They're also built using `xib`s because storyboards on macOS are dumb.
* The app is [`AppleScript`](https://en.wikipedia.org/wiki/AppleScript) enabled by default and includes a sample [`.sdef`](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/AboutScriptingTerminology.html) scripting dictionary because you can't pry `AppleScript` support out of my cold, dead hands.
* Two [helper](https://github.com/tylerhall/DefaultApp/blob/master/macOS/Models/Outlines/OutlineItem.swift) [classes](https://github.com/tylerhall/DefaultApp/blob/master/macOS/Models/Outlines/RootItem.swift) that make building a typical [macOS source list](https://developer.apple.com/documentation/appkit/cocoa_bindings/navigating_hierarchical_data_using_outline_and_split_views?language=objc) easy.
* A few [common controls and `NSView` subclasses](https://github.com/tylerhall/DefaultApp/tree/master/macOS/UI) that I find myself using in nearly every project.
* Sane Xcode defaults for settings such as [enabling insecure HTTP requests in web views](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity?language=objc) but not in the rest of the app and also making the project compatible with [`agvtool`](https://developer.apple.com/library/archive/qa/qa1827/_index.html). Little things such as those that are helpful but nearly impossible to google unless you know what you don't know.
* Pre-configured to [check for app updates with Sparkle](https://sparkle-project.org). (And in the Mac App Store target, Sparkle is completely removed to appease the App Review gods.)
* A fair amount of other miscellaneous code and helper `extension`s that always come up and no one wants to write from scratch each time.
* Pre-written [`Podfile`](https://github.com/tylerhall/DefaultApp/blob/master/Podfile) and [`Cartfile`](https://github.com/tylerhall/DefaultApp/blob/master/Cartfile)s that include the usual open source libraries I include in all of my projects. (I would have migrated to the Swift Package Manager instead, but not everything is available through it yet.)

## Installation

1. Clone this repo.
2. Inside you'll find a small shell script called `renameApp.sh`. This will let you rename the project to something other than `DefaultApp`. To use it, just run this command in a command prompt:

	./renameApp.sh MyAppName

If all goes well, everything will be renamed properly. Note: I haven't tested that command using a name with spaces, so YMMV.

3. The app, by default, includes a few command open source libraries that I typically use in my apps such as [AlamoFire](https://github.com/Alamofire/Alamofire), [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON), and [AppCenter](https://appcenter.ms). You can install these by doing the typical [Cocoapods](https://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage) dance. Or, just feel free to remove them entirely.

## Feedback and Contributions

I'd love to hear your feedback - good or bad. And pull requests and bug reports are always appreciated.

However, I make no apologies for the fact that the choices made in this project are highly opinionated based on my 13 years as an independent developer working primarily on [my own software](https://clickontyler.com). So, like [the accompanying blog post](https://tyler.io/default-app-for-mac-ios) says...

> don’t use this as the basis for a billion dollar corporation’s enterprise app. Or with a team of “100 engineers” “solving hard problems”. But if you’re a one-person development shop or a team of just two or three engineers building a typical macOS shoebox or document based app? Please take a look.
