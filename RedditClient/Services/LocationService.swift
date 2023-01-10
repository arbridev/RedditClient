//
//  LocationService.swift
//  RedditClient
//
//  Created by Armando Brito on 6/1/23.
//

import Foundation
import CoreLocation

class LocationService: NSObject {

    private var locationManager: CLLocationManager!
    private var authorizationChangedToEnabled: (Bool) -> Void = { _ in }

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }

    func requestPermission(completion: ((Bool) -> Void)?) {
        locationManager?.requestWhenInUseAuthorization()
        authorizationChangedToEnabled = { enabled in
            completion?(enabled)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            authorizationChangedToEnabled(true)
            return
        }
        authorizationChangedToEnabled(false)
    }

}
