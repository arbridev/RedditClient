//
//  PersistenceService.swift
//  RedditClient
//
//  Created by Armando Brito on 6/1/23.
//

import UIKit

class PersistenceService {

    private struct PersKey {
        static let isPermissionFlowComplete = "isPermissionFlowComplete"
    }

    private let persistence: UserDefaults = UserDefaults.standard

    var isPermissionFlowComplete: Bool {
        get {
            persistence.bool(forKey: PersKey.isPermissionFlowComplete)
        }
        set {
            persistence.set(newValue, forKey: PersKey.isPermissionFlowComplete)
        }
    }

}
