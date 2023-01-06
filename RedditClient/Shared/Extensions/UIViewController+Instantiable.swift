//
//  UIViewController+Instantiable.swift
//  RedditClient
//
//  Created by Armando Brito on 5/1/23.
//

import UIKit

extension UIViewController: Instantiable {

    static var storyboard: String {
        "Main"
    }

    static var bundle: Bundle? {
        nil
    }

    static var identifier: String {
        String(describing: self)
    }

    static func instantiate() -> Self {
        guard let vc = UIStoryboard(name: storyboard, bundle: bundle)
            .instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Could not instantiate view controller with identifier \(identifier)")
        }

        return vc
    }

}
