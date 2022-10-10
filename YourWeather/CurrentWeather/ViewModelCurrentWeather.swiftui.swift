//
//  ExtentsionContentView.swiftui.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 30.09.2022.
//

import SwiftUI
import CoreLocation

extension CurrentWeatherView{
    class ViewModel: NSObject, ObservableObject,CLLocationManagerDelegate{
        @Published private(set) var currentWeather: CurrentWeather?
        var location = ""
        var lat: Double?
        var lon: Double?
        {
            didSet{

                getStartWeather()
                locationManager?.stopUpdatingLocation()
                locationManager = nil
            }
        }

        
        
        var locationManager:CLLocationManager?
        let network: NetworkProtocol
        init(currentWeather: CurrentWeather? = nil, network: NetworkProtocol = Network(), locationManager:CLLocationManager = CLLocationManager()) {
            self.locationManager = locationManager
            self.currentWeather = currentWeather
            self.network = network
            
            super.init()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.delegate = self

        }
        func getWeather(){
                CLGeocoder().geocodeAddressString(self.location) { (placemark, error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                
                    if let lat = placemark?.first?.location?.coordinate.latitude,
                       let lon = placemark?.first?.location?.coordinate.longitude {
                        self.network.fetchCurrentWeather(lat: lat, lon: lon) { weather in
                            self.currentWeather = weather
                        }
                    }
                }
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last{
                self.lat = location.coordinate.latitude
                self.lon = location.coordinate.longitude
                print(self.lat, self.lon)
            }
        }
        func getStartWeather(){
                self.network.fetchCurrentWeather(lat: self.lat!, lon: self.lon!) { weather in
                    self.currentWeather = weather
                    print(weather)
                }

        }
    }
}
