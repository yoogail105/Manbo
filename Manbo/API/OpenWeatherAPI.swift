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
        
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": APIKeys.weatherKey
            ]
        
        AF.request(Endpoint.weatherURL, method: .get, parameters: parameters).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                //print("api통신 성공: \(value)")
                let json = JSON(value)
                let temp = json["main"]["temp"].doubleValue - 273.15
                
                result(temp)
            case .failure(let error):
                print("weatherErrror: ", error)
            }
        }
    }
}
