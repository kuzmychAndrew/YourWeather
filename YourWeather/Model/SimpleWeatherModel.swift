//
//  SimpleWeatherModel.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 23.09.2022.
//

import Foundation

struct SimpleWeatherModel: Decodable {
    let city: String
    let list: [ListWeather]
}

struct ListWeather: Decodable, Identifiable, Hashable {
    var id = UUID()
    let date: String
    let tempMax: Int
    let tempMin: Int
    let mainWeather: String
    let windSpeed: Double
    let icon: String
    let visibility: Int
}
