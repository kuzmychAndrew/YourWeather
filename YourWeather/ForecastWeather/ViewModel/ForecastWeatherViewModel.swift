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
        private var cancellableSet: Set<AnyCancellable> = []
        @Published private(set) var forecastWeather: SimpleWeatherModel?
        let network: NetworkProtocol
        private let apiKey = "37639423ae4bdf88965382aef6cf3ccd"
        private let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?"
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
            // swiftlint:disable:next line_length
            guard let url = URL(string: "\(self.forecastUrl)lat=\(Double(self.coordinate!.latitude))&lon=\(Double(self.coordinate!.longitude))&units=metric&appid=\(self.apiKey)") else {return}
            self.network.fetchForecastWeather(url: url)
                .sink { [weak self] (dataResponse) in
                    if dataResponse.error != nil {
                        print(dataResponse.error.debugDescription)
                    } else {
                        self?.forecastWeather = self?.toSimpleModel(weather: dataResponse.value!.self)
                    }
                }.store(in: &cancellableSet)
        }
        func getForecastWeather() {
            CLGeocoder().geocodeAddressString(self.location) { [weak self](placemark, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let coordinate = placemark?.first?.location?.coordinate else {return}
                    // swiftlint:disable:next line_length
                    guard let url = URL(string: "\(self?.forecastUrl)lat=\(Double(coordinate.latitude))&lon=\(Double(coordinate.longitude))&units=metric&appid=\(self?.apiKey)") else {return}
                    self?.network.fetchForecastWeather(url: url)
                        .sink { [weak self] (dataResponse) in
                            if dataResponse.error != nil {
                                print(dataResponse.error.debugDescription)
                            } else {
                                self?.forecastWeather = self?.toSimpleModel(weather: dataResponse.value!.self)
                            }
                        }.store(in: &self!.cancellableSet)
                }
            }
        }
        func miliToDate(date: Int) -> String {
            let date = Date(timeIntervalSince1970: TimeInterval((date)))
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let rigthDate = formatter.string(from: date as Date)
            return rigthDate.capitalized
        }
        func toSimpleModel(weather: ForecastWeather) -> SimpleWeatherModel {
            var listWeather: [ListWeather] = []
            var dayOfWeek: [String] = []
            var temp: [Double] = []
            for ind in weather.list {
                let newDate = miliToDate(date: ind.dt)
                if dayOfWeek.contains(newDate) || dayOfWeek.isEmpty {
                    dayOfWeek.append(newDate)
                    temp.append(ind.main.temp)
                } else {
                    let item = ListWeather(date: miliToDate(date: ind.dt),
                                           tempMax: Int(temp.max()!),
                                           tempMin: Int(temp.min()!),
                                           mainWeather: ind.weather[0].weatherDescription,
                                           windSpeed: ind.wind.speed,
                                           icon: ind.weather[0].icon,
                                           visibility: ind.visibility)
                    listWeather.append(item)
                    temp = []
                    dayOfWeek.append(newDate)
                    temp.append(ind.main.temp)
                }
            }
            let mainWeather = SimpleWeatherModel(city: weather.city.name, list: listWeather)
            return mainWeather
        }
    }
}
