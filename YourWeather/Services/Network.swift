//
//  Network.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 22.09.2022.
//

import Foundation
import Alamofire
import CoreLocation

protocol NetworkProtocol{
    func fetchForecastWeather(lat: Double,lon: Double, comletion: @escaping(SimpleWeatherModel) -> ())
    func fetchCurrentWeather(lat: Double,lon: Double ,comletion: @escaping(CurrentWeather) -> ())
}

class Network: ObservableObject, NetworkProtocol {
    
    let forecastApiKey = "37639423ae4bdf88965382aef6cf3ccd"
    let forecastBaseUrl = "https://api.openweathermap.org/data/2.5/forecast?"
    let currentUrl = "https://api.openweathermap.org/data/2.5/weather?"
    
    func fetchForecastWeather(lat: Double,lon: Double, comletion: @escaping(SimpleWeatherModel) -> ()){
        let units = "metric"
        if let forecastUrl = URL(string: "\(forecastBaseUrl)lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(forecastApiKey)"){
            let request = AF.request(forecastUrl)
            request.responseDecodable(of: Welcome.self) { response in
                if let weather = response.value{
                    let simpleWeather = self.toSimpleModel(weather: weather)
                    comletion(simpleWeather)
                } else{
                    print(response.error!)
                }
            }
        }
    }
    func fetchCurrentWeather(lat: Double,lon: Double ,comletion: @escaping(CurrentWeather) -> ()){
        let units = "metric"
        if let currentUrl = URL(string: "\(currentUrl)lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(forecastApiKey)"){
            let request = AF.request(currentUrl)
            request.responseDecodable(of: CurrentWeather.self) { response in
                if let weather = response.value{
                    comletion(weather)
                    
                } else{
                    print(response.error!)
                }
            }
            
        }
    }
    
    func miliToDate(dt:Int)-> String{
        let date = Date(timeIntervalSince1970: TimeInterval((dt)))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let rigthDate = formatter.string(from: date as Date)
        
        return rigthDate.capitalized
    }
    
    func toSimpleModel(weather: Welcome)-> SimpleWeatherModel{
        var listWeather: [ListWeather] = []
        var dayOfWeek:[String] = []
        var temp: [Double] = []
        for i in weather.list{
            let newDate = miliToDate(dt: i.dt)
            if dayOfWeek.contains(newDate) || dayOfWeek.isEmpty{
                dayOfWeek.append(newDate)
                temp.append(i.main.temp)
            }else{
                let item = ListWeather(date: miliToDate(dt: i.dt), tempMax: Int(temp.max()!), tempMin: Int(temp.min()!), mainWeather: i.weather[0].weatherDescription, windSpeed: i.wind.speed, icon: i.weather[0].icon, visibility: i.visibility)
                listWeather.append(item)
                
                temp = []
                dayOfWeek.append(newDate)
                temp.append(i.main.temp)
                
            }
        }
        let mainWeather = SimpleWeatherModel(city: weather.city.name, list: listWeather)
        return mainWeather
    }
    
    
}
