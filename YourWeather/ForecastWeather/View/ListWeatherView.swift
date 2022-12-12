//
//  ListWeatherView.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 27.09.2022.
//

import SwiftUI

public struct ListWeatherView: View {
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
                    .foregroundColor(Color(Asset.Assets.lightGreen.color))
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(Asset.Assets.orange.color))
                    TextField(Strings.ListWeatherView.SearchBar.title, text: $viewModel.location, onCommit: {
                        viewModel.getForecastWeather()
                    })
                    .focused($searching)
                }
                .foregroundColor(.white)
                .padding(.leading, 13)
            }
            .frame(height: 40)
            .cornerRadius(13)
            .padding()
            if let forecastWeather = viewModel.forecastWeather {
                VStack {
                    Text(forecastWeather.city)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .frame(width: 300, height: 50, alignment: .leading)
                        .foregroundColor(Color(Asset.Assets.niceGreen.color))
                    List(forecastWeather.list, id: \.self) {item in
                        HStack {
                            Text(item.date)
                                .frame(width: 100, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 24, weight: .regular, design: .rounded))
                            Spacer()
                            Text("\(item.tempMax)° /")
                                .font(.system(size: 28, weight: .regular, design: .rounded))
                            Text("\(item.tempMin)°")
                                .foregroundColor(Color.secondary)
                                .font(.system(size: 28, weight: .regular, design: .rounded))
                            Spacer()
                            AsyncImage(url: URL(string:
                                                    "https://openweathermap.org/img/wn/\(item.icon)@2x.png")) { image in
                                image.resizable()
                            }placeholder: {
                                Color.white
                            }
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .frame(width: 350, height: 100)
                        .foregroundColor(.white)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .background(Color(Asset.Assets.niceGreen.color))
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, 25)
                }
            } else {
                ProgressView(Strings.ListWeatherView.ProgressView.title)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(Asset.Assets.niceGreen.color)))
            }
        }
    }
}

struct ListWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ListWeatherView()
    }
}
