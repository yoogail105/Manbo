//
//  Manborang++Bundle.swift
//  Manbo
//
//  Created by minjoohehe on 2021/12/01.
//

import Foundation


let resource = "APIKeysInfo"

extension Bundle {
    var WeatherKey: String {
        guard let file = self.path(forResource: resource, ofType: "plist") else {return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource[APIKeyString.WeatherKey.rawValue] as? String else { fatalError(APIKeyString.WeatherKey.rawValue + FatalError.errorMessage.rawValue)}
        return key
    }
    
    var AppStoreID: String {
        guard let file = self.path(forResource: resource, ofType: "plist") else {return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["APPStoreID"] as? String else { fatalError("APPStoreID" + FatalError.errorMessage.rawValue)}
        return key
    }
    
    
}
