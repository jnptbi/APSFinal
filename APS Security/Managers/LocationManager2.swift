//
//  LocationManager2.swift
//  TestLocation
//
//  Created by Vishal Patel on 06/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager2: NSObject, ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()

    let locationManager2 = CLLocationManager()
    
    private let geocoder = CLGeocoder()
    /*
    @Published var placemark: CLPlacemark? {
        willSet { objectWillChange.send() }
    }
    */
    
    @Published var address: String? {
        willSet { objectWillChange.send() }
    }
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }

    override init() {
        super.init()
        self.locationManager2.delegate = self
        self.locationManager2.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager2.requestWhenInUseAuthorization()
        //self.locationManager2.startUpdatingLocation()
        self.locationManager2.startMonitoringSignificantLocationChanges()
        self.locationManager2.allowsBackgroundLocationUpdates = false
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined:
            return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }
    
    func startLocationMonitoring() {
        print("** startLocationMonitoring")
        self.locationManager2.stopMonitoringSignificantLocationChanges()
    }
    
    func stopLocationMonitoring() {
        print("** stopLocationMonitoring")
        self.locationManager2.startMonitoringSignificantLocationChanges()
    }
    
}

extension LocationManager2: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        geocode(loc: location)
        self.locationManager2.stopUpdatingLocation()
        print(#function, location)
    }
    
    private func geocode(loc: CLLocation) {
        let location = loc
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if error == nil {
                let placeMark = places! as [CLPlacemark]
                
                if placeMark.count > 0 {
                    
                    let placeMark = places![0]
                    var addressString : String = ""

                    if placeMark.subThoroughfare != nil {
                        addressString = addressString + placeMark.subThoroughfare! + ", "
                    }
                    if placeMark.thoroughfare != nil {
                        addressString = addressString + placeMark.thoroughfare! + ", "
                    }
                    if placeMark.subLocality != nil {
                        addressString = addressString + placeMark.subLocality! + ", "
                    }

                    if placeMark.locality != nil {
                        addressString = addressString + placeMark.locality! + ", "
                    }
                    if placeMark.administrativeArea != nil {
                        addressString = addressString + placeMark.administrativeArea! + ", "
                    }
                    if placeMark.country != nil {
                        addressString = addressString + placeMark.country! + ", "
                    }
                    if placeMark.postalCode != nil {
                        addressString = addressString + placeMark.postalCode! + " "
                    }

                    self.address = addressString
                    print(addressString)
                    
                }
                
            } else {
                //self.placemark = nil
                self.address = "Not found"
            }
        })
    }

}
