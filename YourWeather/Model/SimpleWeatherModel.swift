//
//  SimpleWeatherModel.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 23.09.2022.
//

import Foundation

struct SimpleWeatherModel: Codable {
    let city: String
    let list: [ListWeather]
}

struct ListWeather: Codable, Identifiable, Hashable {
    var id = UUID()
    let date: String
    // let temp: Double
    let tempMax: Int
    let tempMin: Int
    let mainWeather: String
    let windSpeed: Double
    let icon: String
    let visibility: Int

}
