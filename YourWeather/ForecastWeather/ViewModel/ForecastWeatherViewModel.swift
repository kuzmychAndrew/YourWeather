//
//  ForecastWeatherViewModel.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 05.10.2022.
//

import SwiftUI
import CoreLocation
import Combine

extension ListWeatherView {
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
        @Published private(set) var forecastWeather: SimpleWeatherModel?
        let network: NetworkProtocol
        init(foresactWeather: SimpleWeatherModel? = nil,
             network: NetworkProtocol = Network(),
             locationManager: CLLocationManager = CLLocationManager()) {
            self.locationManager = locationManager
            self.forecastWeather = foresactWeather
            self.network = network
            super.init()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                self.coordinate = location.coordinate
                print(location.coordinate.latitude, location.coordinate.longitude)
            }
        }
        func getStartWeather() {
            self.network.fetchForecastWeather(coordinate: coordinate!) { [weak self] (forecastWeather) in
                self?.forecastWeather = forecastWeather
            }
        }
        func getForecastWeather() {
            CLGeocoder().geocodeAddressString(self.location) { [weak self](placemark, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let coordinate = placemark?.first?.location?.coordinate {
                    self?.network.fetchForecastWeather(coordinate: coordinate) { [weak self] (forecastWeather) in
                        self?.forecastWeather = forecastWeather
                    }
                }
            }
        }
    }
}
