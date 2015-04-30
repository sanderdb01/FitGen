//
//  ConvertUnits.swift
//  FitGen
//
//  Created by David Sanders on 4/20/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import Foundation
public class ConvertUnits {
    class func metersToMiles(distance:Int) -> String {
        if Double(distance) * 0.000621 < 1 {
            return String(format: "%.2f", Double(distance) * 0.000621)
        } else {
            return String(format: "%.1f", Double(distance) * 0.000621)
        }
    }
    
    class func milesToMeters(distance:Int) -> String {
        //return "\(Double(Double(distance) * 0.000621) * 10 / 10)"
        return String(format: "%.1f", Double(distance) * 1610)
    }
    
    class func poundsToKilograms(pounds:Int) -> String {
        return String(format: "%.1f", Double(pounds) * 0.454)
    }
    
    class func kilogramsToPounds(kg:Double) -> String {
        let weight = Int(kg * 2.2)
        return "\(weight)"
    }
}