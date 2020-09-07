//
//  StationStatistics.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 07.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

final class StationStatistics {
    
    var name: String
    var totalLitres: Double
    var totalPrice: Double
    
    init(station: GasStation) {
        self.name = station.title ?? ""
        self.totalPrice = 0
        self.totalLitres = 0
        guard let refuelings = station.refuelings?.allObjects as? [Refueling] else { return }
        for refueling in refuelings {
            self.totalLitres += refueling.litres
            self.totalPrice += refueling.price * refueling.litres
        }
    }
    
}
