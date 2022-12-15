//
//  ContentView.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 22.09.2022.
//

import SwiftUI
import CoreLocation

public struct CurrentWeatherView: View {
    @State var searchText = ""
    @StateObject var viewModel: ViewModel
    @FocusState var searching: Bool
    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    public var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(Asset.Assets.niceGreen.color))
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(Asset.Assets.orange.color))
                    TextField(Strings.CurrentWeatherView.SearchBar.title, text: $viewModel.location, onCommit: {
                        viewModel.getCurrentWeather()
                    })
                    .focused($searching)
                }
                .foregroundColor(.white)
                .padding(.leading, 13)
            }
            .frame(height: 40)
            .cornerRadius(13)
            .padding()
            .padding(.top, 20)
            if let currentWeather = viewModel.currentWeather {
                VStack {
                    Text(currentWeather.name!)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Fells like: \(Int(currentWeather.main!.feelsLike))°")
                        .foregroundColor(Color.secondary)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                    ZStack {
                        Text("\(Int(currentWeather.main!.temp))°")
                            .font(.system(size: 130, weight: .medium, design: .rounded))
                            .gradientForeground(colors: [Color(Asset.Assets.niceGreen.color), .white])
                            .foregroundColor(.white)
                        AsyncImage(url: URL(string:
                                                // swiftlint:disable:next line_length
                                            "https://openweathermap.org/img/wn/\(currentWeather.weather![0].icon)@4x.png")) { image in
                            image.fixedSize()
                        }placeholder: {
                            Color.clear
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: 80)
                        .frame(alignment: .center)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .circular)
                            .foregroundColor(Color(Asset.Assets.lightGreen.color))
                        HStack {
                            VStack {
                                Text(Strings.CurrentWeatherView.Visability.title)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                Text("\(currentWeather.visibility!/100)%")
                                    .font(.system(size: 32, weight: .regular, design: .rounded))
                            }
                            VStack {
                                Text(Strings.CurrentWeatherView.WindSpeed.title)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                Text(String(format: "%g", currentWeather.wind!.speed))
                                    .font(.system(size: 32, weight: .regular, design: .rounded))
                            }
                            .padding()
                            VStack {
                                Text(Strings.CurrentWeatherView.Pressure.title)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                Text("\(Int(currentWeather.main!.pressure))")
                                    .font(.system(size: 32, weight: .regular, design: .rounded))
                            }
                        }
                        .foregroundColor(.white)
                    }.offset(y: 80)
                        .frame(width: 350, height: 100)
                }
            } else {
                ProgressView(Strings.CurrentWeatherView.ProgressView.title)
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
            }
        }
        .padding(.top)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .greatestFiniteMagnitude, alignment: .top)
        .background(Color(Asset.Assets.niceGreen.color))
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
    }
}
extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .bottom,
                endPoint: .top)
        )
        .mask(self)
    }
}
