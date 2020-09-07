//
//  ViewController.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 05.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class StationsVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let coreDataManager = CoreDataManager()
    private var stations = [GasStation]()
    private var chosenStation: GasStation?
    private let firebaseSynchronizer = FirebaseSynchronizer()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAndReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        coreDataManager.removeAllStations()
        firebaseSynchronizer.synchronize { [unowned self] in
            self.fetchAndReload()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchAndReload() {
        stations = coreDataManager.fetchStations()
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: C.newStationSegue, sender: self)
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.newStationSegue, let dest = segue.destination as? NewStationVC {
           dest.delegate = self
        } else if segue.identifier == C.editStationSegue, let dest = segue.destination as? EditStationVC {
            guard let chosenStation = chosenStation else { return }
            dest.delegate = self
            dest.stationToEdit = chosenStation
        } else if segue.identifier == C.addRefuelingSegue, let dest = segue.destination as? AddRefuelingVC {
            guard let chosenStation = chosenStation else { return }
            dest.currentStation = chosenStation
        }
    }
    
}

// MARK: - NewStationVCDelegate
extension StationsVC: ReturningToParentWithChangesDelegate {
    
    func didFinishAddingStation() {
        fetchAndReload()
    }
    
}
// MARK: - UITableViewDelegate
extension StationsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: C.editTitle) { [unowned self] (_, _, _) in
            let stationToEdit = self.stations[indexPath.row]
            self.chosenStation = stationToEdit
            self.performSegue(withIdentifier: C.editStationSegue, sender: self)
        }
        editAction.backgroundColor = .systemGreen
        let deleteAction = UIContextualAction(style: .destructive, title: C.deleteTitle) { [unowned self] (_, _, _) in
            let stationToDelete = self.stations[indexPath.row]
            self.coreDataManager.delete(station: stationToDelete)
            self.stations.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeActionsConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.chosenStation = self.stations[indexPath.row]
        performSegue(withIdentifier: C.addRefuelingSegue, sender: self)
    }
    
}
// MARK: - UITableViewDataSource
extension StationsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: C.stationCellIdentifier, for: indexPath) as? StationCell else { return UITableViewCell() }
        let station = stations[indexPath.row]
        cell.stationTitleLabel.text = station.title ?? ""
        cell.stationFuelProviderLabel.text = station.fuelProvider ?? ""
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
