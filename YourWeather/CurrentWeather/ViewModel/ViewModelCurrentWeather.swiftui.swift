//
//  ExtentsionContentView.swiftui.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 30.09.2022.
//

import SwiftUI
import CoreLocation

extension CurrentWeatherView {
    final class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        var location = ""
        var locationManager: CLLocationManager?
        var coordinate: CLLocationCoordinate2D? {
            didSet {
                getStartWeather()
                locationManager?.stopUpdatingLocation()
                locationManager = nil
            }
        }
        @Published private(set) var currentWeather: CurrentWeather?
        let network: NetworkProtocol
        init(currentWeather: CurrentWeather? = nil,
             network: NetworkProtocol = Network(),
             locationManager: CLLocationManager = CLLocationManager()) {
            self.locationManager = locationManager
            self.currentWeather = currentWeather
            self.network = network
            super.init()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
        func getWeather() {
            CLGeocoder().geocodeAddressString(self.location) {[weak self] (placemark, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let coordinate = placemark?.first?.location?.coordinate {
                    self?.network.fetchCurrentWeather(coordinate: coordinate) { [weak self] (weather) in
                        self?.currentWeather = weather
                    }
                }
            }
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                self.coordinate = location.coordinate
                print(location.coordinate.latitude, location.coordinate.longitude)
            }
        }
        func getStartWeather() {
            self.network.fetchCurrentWeather(coordinate: coordinate!) { [weak self] (weather) in
                self?.currentWeather = weather
            }
        }
    }
}
