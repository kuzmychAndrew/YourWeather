////
////  ListWeatherView.swift
////  YourWeather
////
////  Created by Андрій Кузьмич on 27.09.2022.
////
//
//import SwiftUI
//
//struct ListWeatherView: View{
//    
//    
//    //@State var weather: SimpleWeatherModel?
//    
//    
//    @ObservedObject var network = Network(city: "Kyiv")
//    var niceGreen: Color = Color(red: 55/255  , green: 118/255 , blue: 127/255)
//    
//    var body: some View {
//        
//        if network.forecastWeather != nil{
//            VStack{
//                List(network.forecastWeather!.list, id: \.self){item in
//                    HStack{
//                        Text(item.date)
//                            .frame(width: 100)
//                            .multilineTextAlignment(.leading)
//                            .font(.system(size: 24, weight: .regular, design: .rounded))
//                        Spacer()
//                        Text("\(item.tempMax)° /")
//                            .font(.system(size: 28, weight: .regular, design: .rounded))
//                        Text("\(item.tempMin)°")
//                            .foregroundColor(Color.secondary)
//                            .font(.system(size: 28, weight: .regular, design: .rounded))
//                        
//                        Spacer()
//                        AsyncImage(url: URL(string:
//                                                "https://openweathermap.org/img/wn/\(item.icon)@2x.png")){ image in
//                            image.resizable()
//                            
//                            
//                        }placeholder: {
//                            Color.white
//                        }
//                        .frame(width: 70,height: 70)
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                        
//                    }
//                    .frame(width: 350, height: 100)
//                    .foregroundColor(.white)
//                    .listRowSeparator(.hidden)
//                    .listRowInsets(EdgeInsets())
//                    .listRowBackground(Color.clear)
//                    //.ignoresSafeArea(edges: .horizontal)
//                    .background(niceGreen)
//                    .cornerRadius(10)
//                    //.deleteDisabled(true)
//                    
//                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
//
//                    
//                }
//                
//            }
//            
//            .padding(.top, 40)
//            
//
//        }else{
//            ProgressView("Please wait...")
//                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
//        }
//    }
//        
//    
//}
//
//
//
//
//struct ListWeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListWeatherView()
//    }
//}
