//
//  String+Localization.swift
//  RedditClient
//
//  Created by Armando Brito on 8/1/23.
//

import Foundation

extension String {

    var localized: String {
        Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }

}
