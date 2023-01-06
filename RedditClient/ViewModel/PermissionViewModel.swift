//
//  PermissionViewModel.swift
//  RedditClient
//
//  Created by Armando Brito on 6/1/23.
//

import Foundation
import AVFoundation
import UserNotifications

class PermissionViewModel {

    private let persistenceService = PersistenceService()
    private let locationService = LocationService()

    var permissionKind: PermissionKind = .camera

    var title: String {
        switch permissionKind {
            case .camera:
                return "Camera"
            case .notifications:
                return "Notifications"
            case .location:
                return "Location"
        }
    }

    var description: String {
        switch permissionKind {
            case .camera:
                return "Camera"
            case .notifications:
                return "Notifications"
            case .location:
                return "Location"
        }
    }

    init(permissionKind: PermissionKind) {
        self.permissionKind = permissionKind
    }

    func nextPermission() -> PermissionKind? {
        let navFlow = Constant.permissionNavigationFlow
        var nextPermissionKind: PermissionKind?
        if let navFlowIndex = navFlow.firstIndex(of: permissionKind),
           navFlowIndex + 1 < navFlow.count {
            nextPermissionKind = navFlow[navFlowIndex + 1]
        } else {
            // We are in the last screen of the permissions flow
            persistenceService.isPermissionFlowComplete = true
        }
        return nextPermissionKind
    }

    func allowCamera(completion: ((Bool) -> Void)?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                completion?(true)
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        completion?(true)
                    }
                }
            case .denied: // The user has previously denied access.
                completion?(false)
                return
            case .restricted: // The user can't grant access due to restrictions.
                completion?(false)
                return
            @unknown default:
                fatalError("Unknown authorization status when allowing camera")
        }
    }

    func enableNotifications(completion: ((Bool) -> Void)?) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                print(error)
                completion?(false)
            }

            completion?(true)
        }
    }

    func enableLocation(completion: ((Bool) -> Void)?) {
        locationService.requestPermission(completion: completion)
    }

}