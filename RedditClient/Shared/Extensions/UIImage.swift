//
//  UIImage.swift
//  RedditClient
//
//  Created by Armando Brito on 8/1/23.
//

import UIKit

extension UIImage {

    struct Icon {
        static let magnifyingGlass = UIImage(systemName: "magnifyingglass")!
    }

    struct Background {
        static let defaultStyle = UIImage(named: "launch_bg")!
    }

    struct Permissions {
        static let camera = UIImage(named: "camera")!
        static let bell = UIImage(named: "bell")!
        static let map = UIImage(named: "map")!
    }

}
