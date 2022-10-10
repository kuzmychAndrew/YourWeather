//
//  StartView.swift
//  YourWeather
//
//  Created by Андрій Кузьмич on 28.09.2022.
//

import SwiftUI

struct StartView: View {
    @State var index = 0
    var body: some View {
        NavigationView {
            TabView(){
                CurrentWeatherView()
                    .tag(0)
                    .tabItem {
                        Label("Current", systemImage: "cloud.circle")
                    }
                ListWeatherView()
                    .tag(1)
                    .tabItem {
                        Label("Weekly", systemImage : "calendar.circle")
                    }
            }
            .accentColor(.orange)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
