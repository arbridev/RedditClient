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
        let permissionVM = PermissionViewModel(permissionKind: .location)
        XCTAssertEqual(permissionVM.title, "permission.location.title".localized)
        XCTAssertEqual(permissionVM.description, "permission.location.description".localized)
    }

}
