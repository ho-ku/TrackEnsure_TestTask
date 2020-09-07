//
//  Converter.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 07.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

final class Converter {
    
    static func convert(from stations: [GasStation]) -> [[String: Any]] {
        var result: [[String: Any]] = []
        for station in stations {
            var refuelingsArr: [[String: Any]] = []
            if let refuelings = station.refuelings?.allObjects as? [Refueling] {
                for refueling in refuelings {
                    var refuelingsDict: [String: Any] = [:]
                    refuelingsDict["fuelType"] = refueling.fuelType!
                    refuelingsDict["litres"] = refueling.litres
                    refuelingsDict["price"] = refueling.price
                    refuelingsArr.append(refuelingsDict)
                }
            }
            var currentDict: [String: Any] = [:]
            currentDict[station.id!] = ["title": station.title!, "lat": station.lat, "lon": station.lon, "fuelProvider": station.fuelProvider!, "refuelings": refuelingsArr]
            result.append(currentDict)
        }
        return result
    }
    
}
