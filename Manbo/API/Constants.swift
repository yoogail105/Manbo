//
//  Constants.swift
//  Manbo
//
//  Created by 성민주민주 on 2022/04/27.
//

import Foundation
import Alamofire



enum APIKeyString: String {
    case WeatherKey = "Weather_KEY"
}

struct APIKeys {
    static let weatherKey = Bundle.main.WeatherKey
}

enum FatalError: String {
    case errorMessage = "설정을 해주세요."
}



struct Endpoint {
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
}
