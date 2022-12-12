import Foundation
import Alamofire

struct CurrentWeather: Decodable {
    let weather: [Weather]?
    let main: MainWeather?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}
// MARK: - Welcome
struct ForecastWeather: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [WeatherList]
    let city: City
}

// MARK: - City
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Decodable {
    let lat, lon: Double
}

// MARK: - List
struct WeatherList: Decodable {
    let dt: Int
    let main: MainWeather
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, rain, pop
    }
}

// MARK: - Clouds
struct Clouds: Decodable {
    let all: Int
}

// MARK: - MainClass
struct MainWeather: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure: Int
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
    }
}

// MARK: - Rain
struct Rain: Decodable {
    let the3H: Double
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
