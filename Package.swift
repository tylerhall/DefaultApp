// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        // .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
		// .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0"))
		// Sadness...
		// Sparkle and MS AppCenter aren't yet available. So I'm disabling Swift PM for now.
		// Just use CocoaPods, Carthage, or install everything by hand instead if you'd like.
    ]
)