//
//  LocationManager.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 16/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation

protocol LocationAuthorizationManagerProtocol {

    var authorizationStatus: CLAuthorizationStatus { get }

    var authorizationDidChangeEvent: ((CLAuthorizationStatus) -> Void)? { get set }

    var areServicesEnabled: Bool { get }

    func requestAuthorizationIfNeeded()

}

protocol LocationTrackerProtocol {
    var currentLocation: CLLocation? { get }

    func updateLocation()

    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void)

}

typealias LocationManagerProtocol = LocationAuthorizationManagerProtocol & LocationTrackerProtocol

extension LocationAuthorizationManagerProtocol {

    var isLocationUsageEnabled: Bool {
        if !areServicesEnabled {
            return false
        }
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}


final class LocationManager: LocationManagerProtocol {
    static let shared = LocationManager()
    
    private let timeout: TimeInterval = 5

    var currentLocation: CLLocation? {
        return Locator.currentLocation
    }

    var authorizationStatus: CLAuthorizationStatus {
        return Locator.authorizationStatus
    }

    var areServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    var authorizationDidChangeEvent: ((CLAuthorizationStatus) -> Void)?

    func requestAuthorizationIfNeeded() {
        Locator.requestAuthorizationIfNeeded(.whenInUse)
        LocationManager.startUpdatingLocationIfNeeded()
    }

    func updateLocation() {
        LocationManager.startUpdatingLocationIfNeeded()
    }

    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        if Locator.authorizationStatus == .notDetermined || currentLocation != nil {
            completion(currentLocation)
            return
        }

        Locator.currentPosition(accuracy: .block, timeout: .after(timeout), onSuccess: { location in
            completion(location)
        }, onFail: { (_, location) in
            completion(location)
        })
    }

    private var listenerToken: LocatorManager.Events.Token = 0

    init() {
        listenerToken = Locator.events.listen(forAuthChanges: { [weak self] status in
            self?.authorizationDidChangeEvent?(status)
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                LocationManager.startUpdatingLocationIfNeeded()
            default:
                break
            }
        })
    }

    deinit {
        Locator.events.remove(token: listenerToken)
    }

    static func startUpdatingLocationIfNeeded() {
        if Locator.authorizationStatus == .notDetermined {
            // do not update location if user haa't made an explicit choice yet
            return
        }
        if Locator.isUpdatingLocation {
            return
        }
        Locator.currentPosition(accuracy: .block, onSuccess: { _ in

        }, onFail: { _, _ in

        })
        Locator.subscribePosition(accuracy: .block, onUpdate: { _ in

        }, onFail: { _, _ in

        })
    }

}
