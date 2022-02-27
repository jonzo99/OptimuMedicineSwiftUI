//
//  PunchViewModel.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/26/22.
//

import MapKit
// NSObject so when can access the delegate methods
enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
}
final class PunchViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("SHow an alert that there location is off and they need to turn it on")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restriced lickey due to parental controls")
        case .denied:
            print("YOU have denined go to the settings to turn them on")
        case .authorizedAlways, .authorizedWhenInUse:
            // unwrapp this
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
