//
//  FirebaseSynchronizer.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 07.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation
import Firebase
import CoreData
import CoreLocation

final class FirebaseSynchronizer {
    
    private let ref = Database.database().reference()
    private let coredataManager = CoreDataManager()
    
    func saveChanges() {
        let stations = coredataManager.fetchStations()
        let dict = Converter.convert(from: stations)
        self.ref.setValue(dict)
    }
    
    func synchronize(completionHandler: @escaping () -> Void) {
        ref.observeSingleEvent(of: .value) { [unowned self] (snapshot) in
            guard let stations = snapshot.value as? NSArray else { return }
            for (index, station) in stations.enumerated() {
                guard let dict = station as? [String: Any], let value = Array(dict.values).first as? [String: Any], let fuelProvider = value["fuelProvider"] as? String, let lat = value["lat"] as? Double, let lon = value["lon"] as? Double, let name = value["title"] as? String  else { return }
                self.coredataManager.addStation(name: name, provider: fuelProvider, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                guard let currentStation = self.coredataManager.fetchStations().last, let refuelings = value["refuelings"] as? NSArray else { return }
                for refueling in refuelings {
                    guard let ref = refueling as? [String: Any], let price = ref["price"] as? Double, let litres = ref["litres"] as? Double, let fuelType = ref["fuelType"] as? String else { return }
                    self.coredataManager.addRefueling(to: currentStation, fuelType: fuelType, amount: litres, cost: price)
                }
                if index == stations.count - 1 {
                    completionHandler()
                }
            }
        }
    }
    
}
