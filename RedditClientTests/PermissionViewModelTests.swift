//
//  PermissionViewModelTests.swift
//  RedditClientTests
//
//  Created by Armando Brito on 6/1/23.
//

import XCTest
@testable import RedditClient

final class PermissionViewModelTests: XCTestCase {

    func test_when_permission_is_camera() throws {
        let permissionVM = PermissionViewModel(permissionKind: .camera)
        XCTAssertEqual(permissionVM.title, "permission.camera.title".localized)
        XCTAssertEqual(permissionVM.description, "permission.camera.description".localized)
    }

    func test_when_permission_is_notifications() throws {
        let permissionVM = PermissionViewModel(permissionKind: .notifications)
        XCTAssertEqual(permissionVM.title, "permission.notifications.title".localized)
        XCTAssertEqual(permissionVM.description, "permission.notifications.description".localized)
    }

    func test_when_permission_is_location() throws {
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
        #warning("This is only for demostration purposes, securing this values is not recommended")
        let securePersistence = SecurePersistenceService(configuration: config)
        let permissionVM = PermissionViewModel(permissionKind: .location, persistence: securePersistence)
        XCTAssertEqual(permissionVM.title, "permission.location.title".localized)
        XCTAssertEqual(permissionVM.description, "permission.location.description".localized)
        XCTAssertFalse(securePersistence.isPermissionFlowComplete)
        let nextPermission = permissionVM.nextPermission()
        XCTAssertNil(nextPermission)
        XCTAssertTrue(securePersistence.isPermissionFlowComplete)
        keychainWrapper.removeObject(forKey: "isPermissionFlowComplete")
        XCTAssertFalse(securePersistence.isPermissionFlowComplete)
    }

}
