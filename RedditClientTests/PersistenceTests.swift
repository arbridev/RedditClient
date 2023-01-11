//
//  PersistenceTests.swift
//  RedditClientTests
//
//  Created by Armando Brito on 11/1/23.
//

import XCTest
@testable import RedditClient

final class PersistenceTests: XCTestCase {

    func testSecurePersistence() throws {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            XCTFail("No bundle identifier")
            return
        }
        let uniqueServiceName = "test_sec_pers_\(bundleIdentifier)"
        let keychainWrapper = KeychainWrapper(serviceName: uniqueServiceName)
        let config = SecurePersistenceService.Configuration(
            serviceName: uniqueServiceName,
            accessGroup: nil
        )
        let securePersistence = SecurePersistenceService(configuration: config)
        XCTAssertFalse(securePersistence.isPermissionFlowComplete)
        securePersistence.isPermissionFlowComplete = true
        XCTAssertTrue(securePersistence.isPermissionFlowComplete)
        keychainWrapper.removeObject(forKey: "isPermissionFlowComplete")
        XCTAssertFalse(securePersistence.isPermissionFlowComplete)
    }

}
