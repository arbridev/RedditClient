//
//  UITableViewCell.swift
//  RedditClient
//
//  Created by Armando Brito on 8/1/23.
//

import UIKit

extension UITableViewCell {

    static var identifier: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: identifier, bundle: Bundle(for: self))
    }

}
