//
//  Network.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 22.09.2022.
//

import Foundation
import Alamofire
import CoreLocation
import Combine

protocol NetworkProtocol {
    func fetchForecastWeather(url: URL)-> AnyPublisher<DataResponse<ForecastWeather, NetworkError>, Never>
    func fetchCurrentWeather(url: URL) -> AnyPublisher<DataResponse<CurrentWeather, NetworkError>, Never>
}

final class Network: ObservableObject, NetworkProtocol {
    func fetchForecastWeather(url: URL)-> AnyPublisher<DataResponse<ForecastWeather, NetworkError>, Never> {
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: ForecastWeather.self)
            .map {  response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func fetchCurrentWeather(url: URL) -> AnyPublisher<DataResponse<CurrentWeather, NetworkError>, Never> {
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: CurrentWeather.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
