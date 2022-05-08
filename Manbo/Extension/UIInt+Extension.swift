//
//  UIInt+Extension.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/30.
//

import Foundation
extension Int {
    
    func numberFormat() -> String {
        let number = NumberFormatter()
        number.numberStyle = .decimal
        let result = number.string(for: self)!
        
        return result
    }
}
