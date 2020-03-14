//
//  UIStoryboard+Factory.swift
//

import Foundation
import UIKit

protocol StoryboardLoadable {
    static func StoryboardName() -> String
    static func StoryboardIdentifier() -> String
}

extension StoryboardLoadable where Self: UIViewController {
    static func StoryboardName() -> String {
        return String(describing: Self.self)
    }
    
    static func StoryboardIdentifier() -> String {
        return String(describing: Self.self)
    }
}

private class UIStoryboardFactory {
    
    static var storyboards: [String: UIStoryboard] = [String: UIStoryboard]()
    
    static func storyboard(_ name: String) -> UIStoryboard {
        if UIStoryboardFactory.storyboards.index(forKey: name) != nil {
            return UIStoryboardFactory.storyboards[name]!
        }
        let storyboard = UIStoryboard(name: name, bundle: nil)
        UIStoryboardFactory.storyboards[name] = storyboard

        return storyboard
    }
}

extension UIStoryboard {

    static func loadInitialViewController<T>() -> T where T: StoryboardLoadable, T: UIViewController {
        guard let navigationController = UIStoryboardFactory.storyboard(T.StoryboardName()).instantiateInitialViewController() as? UINavigationController else {
            return UIStoryboardFactory.storyboard(T.StoryboardName()).instantiateInitialViewController() as! T
        }
        return navigationController.viewControllers.first as! T
    }
    
    static func loadViewController<T>() -> T where T: StoryboardLoadable, T: UIViewController {
        return UIStoryboard(name: T.StoryboardName(), bundle: nil).instantiateViewController(withIdentifier: T.StoryboardIdentifier()) as! T
    }

}
