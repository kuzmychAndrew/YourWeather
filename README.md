# YourWeather
🌦An application where you can see the current weather in your city or any other and the weather for 5 days.🌦

The user interface was written using SwiftUI. The used architecture - MVVM. 

### Current weather screen

![photo_2022-10-10_19-16-15](https://user-images.githubusercontent.com/89782153/194910827-e745a22c-6a8e-4eb3-ba18-297e9f2a1de9.jpg)

  When the application starts, CoreLocation determines the location of the user and sends a request to the server with the coordinates. We get JSON in response with current weather.
 Also, the user can find the weather of any desired city using the search at the top of the screen. The weather forecast consists of temperature, visibility, wind speed, and pressure

### Weekly weather

![photo_2022-10-10_19-14-24](https://user-images.githubusercontent.com/89782153/194910475-af849d2f-f0e4-4c70-8d3f-36f709563d56.jpg)

Just like on the first screen when the application starts, CoreLocation determines the location of the user and sends a request to the server with the coordinates. We get JSON in response with weekly weather.
The user can also get weekly weather in any desired city. Weekly weather includes a 5-day forecast with daily high and low temperatures and an illustrated explanation of the weather.
