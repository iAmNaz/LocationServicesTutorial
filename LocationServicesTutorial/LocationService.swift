//
//  LocationService.swift
//  LocationServicesTutorial
//
//  Created by naz on 2/3/21.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func authorizationRestricted()
    func authorizationUknown()
    func promptAuthorizationAction()
    func didAuthorize()
}

class LocationService: NSObject {
    weak var delegate: LocationServiceDelegate?
    
    private var locationManager: CLLocationManager!
    
    var enabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .denied:
            print("denied")
            //ask user to authorize
            delegate?.promptAuthorizationAction()
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
            //inform the user
            delegate?.authorizationRestricted()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            //didAuthorized
            delegate?.didAuthorize()
        case .authorizedAlways:
            print("authorizedAlways")
            //didAuthorized
            delegate?.didAuthorize()
        default:
            print("unknown")
            //inform the user
            delegate?.authorizationUknown()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
}
