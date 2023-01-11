//
//  SecurePersistenceService.swift
//  RedditClient
//
//  Created by Armando Brito on 11/1/23.
//

import Foundation

class SecurePersistenceService: Persistence {

    struct Configuration {
        let serviceName: String
        let accessGroup: String?
    }

    private struct PersKey {
        static let isPermissionFlowComplete = "isPermissionFlowComplete"
    }

    private var persistence = KeychainWrapper.standard

    init(configuration: SecurePersistenceService.Configuration? = nil) {
        if let configuration {
            self.persistence = KeychainWrapper(
                serviceName: configuration.serviceName,
                accessGroup: configuration.accessGroup
            )
            return
        }
        self.persistence = KeychainWrapper.standard
    }

    init(keychainWrapper: KeychainWrapper? = nil) {
        if let keychainWrapper {
            self.persistence = keychainWrapper
            return
        }
        self.persistence = KeychainWrapper.standard
    }

    #warning("This kind of value should not be secured")
    var isPermissionFlowComplete: Bool {
        get {
            persistence.bool(forKey: PersKey.isPermissionFlowComplete) ?? false
        }
        set {
            persistence.set(newValue, forKey: PersKey.isPermissionFlowComplete)
        }
    }

}
