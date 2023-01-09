//
//  UIView.swift
//  RedditClient
//
//  Created by Armando Brito on 8/1/23.
//

import UIKit

extension UIView {

    func addShadow() {
        layer.shadowColor = UIColor.Defined.dark.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
    }

}
