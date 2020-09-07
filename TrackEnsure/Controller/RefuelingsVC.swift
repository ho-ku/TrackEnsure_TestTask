//
//  RefuelingsVC.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 07.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class RefuelingsVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let coredataManager = CoreDataManager()
    private var stationStatistics = [StationStatistics]()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureTableView()
        fetchAndReload()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchAndReload() {
        stationStatistics = []
        let stations = coredataManager.fetchStations()
        for station in stations {
            stationStatistics.append(StationStatistics(station: station))
        }
        tableView.reloadData()
    }

}

// MARK: - UITableViewDelegate
extension RefuelingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
// MARK: - UITableViewDataSource
extension RefuelingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationStatistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: C.statisticsCellIdentifier, for: indexPath) as? StatisticsCell else { return UITableViewCell() }
        let currentStatistics = stationStatistics[indexPath.row]
        cell.stationTitleLabel.text = currentStatistics.name
        cell.costLabel.text = String(currentStatistics.totalPrice)
        cell.litresLabel.text = String(currentStatistics.totalLitres)
        return cell
    }
    
}
