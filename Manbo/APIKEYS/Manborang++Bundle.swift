//
//  Manborang++Bundle.swift
//  Manbo
//
//  Created by minjoohehe on 2021/12/01.
//

import Foundation


extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "WeatherInfo", ofType: "plist") else {return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("WeatherInfo.plist에 API_KEY 설정을 해주세요.")}
        return key
    }
    
    
}
