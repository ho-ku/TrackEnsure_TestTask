//
//  CoreDataManager.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 05.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

final class CoreDataManager {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // MARK: - Working with gas stations
    func addStation(name: String, provider: String, coordinate: CLLocationCoordinate2D) {
        guard let appDelegate = appDelegate, let managedContext = managedContext else { return }
        let newStation = GasStation(entity: GasStation.entity(), insertInto: managedContext)
        newStation.title = name
        newStation.fuelProvider = provider
        newStation.lat = coordinate.latitude
        newStation.lon = coordinate.longitude
        newStation.id = "station\(fetchStations().count)"
        appDelegate.saveContext()
    }
    
    func delete(station: GasStation) {
        guard let appDelegate = appDelegate, let managedContext = managedContext else { return }
        managedContext.delete(station)
        appDelegate.saveContext()
    }
    
    func removeAllStations() {
        let stations = fetchStations()
        for station in stations {
            delete(station: station)
        }
    }
    
    func changeStationInfo(_ station: GasStation, newName: String?, newProvider: String?) {
        guard let appDelegate = appDelegate else { return }
        if let name = newName {
            station.title = name
        }
        if let provider = newProvider {
            station.fuelProvider = provider
        }
        appDelegate.saveContext()
    }
    
    func fetchStations() -> [GasStation] {
        let fetchRequest = NSFetchRequest<GasStation>(entityName: "GasStation")
        guard let managedContext = managedContext else { return [] }
        guard let results = try? managedContext.fetch(fetchRequest) else { return [] }
        return results
    }
    
    // MARK: - Working with refuelings
    func addRefueling(to station: GasStation, fuelType: String, amount: Double, cost: Double) {
        guard let appDelegate = appDelegate, let managedContext = managedContext else { return }
        let newRefueling = Refueling(entity: Refueling.entity(), insertInto: managedContext)
        newRefueling.fuelType = fuelType
        newRefueling.litres = amount
        newRefueling.price = cost
        station.addToRefuelings(newRefueling)
        appDelegate.saveContext()
    }
}
