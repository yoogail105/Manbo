//
//  OpenWeatherAPI.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/26.
//
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class OpenWeatherAPIManager {
    
    static let shared = OpenWeatherAPIManager()
    
    func fetchWeatherInformation(latitude: Double, longitude: Double, result: @escaping (Double) -> ()) {
        
        let appid = Bundle.main.apiKey
   
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(appid)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let temp = json["main"]["temp"].doubleValue - 273.15
                
                result(temp)
            case .failure(let error):
                print(error)
            }
        }
    }
}
