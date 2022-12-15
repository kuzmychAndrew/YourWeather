//
//  ExtentsionContentView.swiftui.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 30.09.2022.
//

import SwiftUI
import CoreLocation
import Combine

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
        private var cancellableSet: Set<AnyCancellable> = []
        @Published private(set) var currentWeather: CurrentWeather?
        let network: NetworkProtocol
        private let apiKey = "37639423ae4bdf88965382aef6cf3ccd"
        private let currentUrl = "https://api.openweathermap.org/data/2.5/weather?"
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
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                self.coordinate = location.coordinate
                print(location.coordinate.latitude, location.coordinate.longitude)
            }
        }
        func getCurrentWeather() {
            CLGeocoder().geocodeAddressString(self.location) {[weak self] (placemark, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let coordinate = placemark?.first?.location!.coordinate else { return }
                    // swiftlint:disable:next line_length
                    guard let url = URL(string: "\(self?.currentUrl)lat=\(Double(coordinate.latitude))&lon=\(Double(coordinate.longitude))&units=metric&appid=\(self?.apiKey)") else {return}
                    self?.network.fetchCurrentWeather(url: url)
                        .sink { [self] (dataResponse) in
                            if dataResponse.error != nil {
                                print(dataResponse.error.debugDescription)
                            } else {
                                self?.currentWeather = dataResponse.value!.self
                            }
                        }.store(in: &self!.cancellableSet)
                }
            }
        }
        func getStartWeather() {
            // swiftlint:disable:next line_length
            guard let url = URL(string: "\(currentUrl)lat=\(Double(self.coordinate!.latitude))&lon=\(Double(self.coordinate!.longitude))&units=metric&appid=\(apiKey)") else {return}
            self.network.fetchCurrentWeather(url: url)
                .sink { [weak self] (dataResponse) in
                    if dataResponse.error != nil {
                        print(dataResponse.error.debugDescription)
                    } else {
                        self?.currentWeather = dataResponse.value!.self
                    }
                }.store(in: &cancellableSet)
        }
    }
}
