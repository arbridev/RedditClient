//
//  Instantiable.swift
//  RedditClient
//
//  Created by Armando Brito on 5/1/23.
//

import UIKit

protocol Instantiable where Self: UIViewController {

    static var storyboard: String { get }
    static var bundle: Bundle? { get }
    static var identifier: String { get }

    static func instantiate() -> Self

}
