//
//  ContentView.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 22.09.2022.
//

import SwiftUI
import CoreLocation

struct CurrentWeatherView: View {
    
    @State var searchText = ""
    @FocusState var searching: Bool
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()){
        _viewModel = StateObject(wrappedValue: viewModel)
                }
    
    var body: some View {
        VStack{
            ZStack {
                Rectangle()
                    .foregroundColor(Color("LightGree"))
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("Orange"))
                    TextField("Search ..", text: $viewModel.location, onCommit: {
                                                    viewModel.getWeather()
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
            if viewModel.currentWeather != nil{
                VStack {
                    Text(viewModel.currentWeather!.name)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Fells like: \(Int(viewModel.currentWeather!.main.feelsLike))°")
                        .foregroundColor(Color.secondary)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                    ZStack{
                        Text("\(Int(viewModel.currentWeather!.main.temp))°")
                            .font(.system(size: 130, weight: .medium, design: .rounded))
                            .gradientForeground(colors: [Color("NiceGreen"), .white])
                            .foregroundColor(.white)
                        
                        AsyncImage(url: URL(string:
                                                "https://openweathermap.org/img/wn/\(viewModel.currentWeather!.weather[0].icon)@4x.png")){ image in
                            //image.scaledToFill()
                            
                            image.fixedSize()
                            
                            
                        }placeholder: {
                            Color.clear
                        }
                        
                        //.frame(width: 600,height: 600)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: 80)
                        
                        .frame(alignment: .center)
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 30, style: .circular)
                        //.background(niceGreen2)
                        
                            .foregroundColor(Color("LightGreen"))
                        HStack{
                            
                            
                            VStack{
                                Text("Visibility")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                
                                Text("\(viewModel.currentWeather!.visibility/100)%")
                                    .font(.system(size: 32, weight: .regular, design: .rounded))
                            }
                            
                            VStack{
                                Text("Wind Speed")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                Text(String(format: "%g", viewModel.currentWeather!.wind.speed))
                                    .font(.system(size: 32, weight: .regular, design: .rounded))
                            }
                            .padding()
                            VStack{
                                Text("Pressure")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                Text("\(Int(viewModel.currentWeather!.main.pressure))")
                                    .font(.system(size: 32, weight: .regular, design: .rounded))
                            }
                            
                        }
                        
                        .foregroundColor(.white)
                    }.offset(y: 80)
                        .frame(width: 350, height: 100)
                }
                
            }else{
                ProgressView("Please wait...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
            }
                
        }
        .padding(.top)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .greatestFiniteMagnitude,alignment: .top)
        .background(Color("NiceGreen"))
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
