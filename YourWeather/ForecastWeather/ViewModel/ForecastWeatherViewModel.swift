//
//  ForecastWeatherViewModel.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 05.10.2022.
//

import SwiftUI
import CoreLocation

extension ListWeatherView {
    class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published private(set) var forecastWeather: SimpleWeatherModel?
        var location = ""
        var lat: Double?
        var locationManager: CLLocationManager?
        let network: NetworkProtocol
        var lon: Double? {
            didSet {
                getStartWeather()
                locationManager?.stopUpdatingLocation()
                locationManager = nil
            }
        }

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
                self.lat = location.coordinate.latitude
                self.lon = location.coordinate.longitude
                print(self.lat as Any, self.lon as Any)
            }
        }

        func getStartWeather() {
            self.network.fetchForecastWeather(lat: self.lat!, lon: self.lon!) { forecastWeather in
                self.forecastWeather = forecastWeather
            }
        }

        func getForecastWeather() {
            CLGeocoder().geocodeAddressString(self.location) { (placemark, error) in
                if let error = error {
                    print(error.localizedDescription)
                }

                if let lat = placemark?.first?.location?.coordinate.latitude,
                   let lon = placemark?.first?.location?.coordinate.longitude {
                    self.network.fetchForecastWeather(lat: lat, lon: lon) { forecastWeather in
                        self.forecastWeather = forecastWeather
                    }
                }
            }
        }

    }
}
