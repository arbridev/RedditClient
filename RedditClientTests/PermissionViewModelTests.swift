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
        XCTAssertEqual(permissionVM.title, "Camera")
        XCTAssertEqual(permissionVM.description, "Camera")
    }

    func test_when_permission_is_notifications() throws {
        let permissionVM = PermissionViewModel(permissionKind: .notifications)
        XCTAssertEqual(permissionVM.title, "Notifications")
        XCTAssertEqual(permissionVM.description, "Notifications")
    }

    func test_when_permission_is_location() throws {
        let permissionVM = PermissionViewModel(permissionKind: .location)
        XCTAssertEqual(permissionVM.title, "Location")
        XCTAssertEqual(permissionVM.description, "Location")
    }

}
