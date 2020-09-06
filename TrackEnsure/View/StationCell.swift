//
//  StationCell.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 06.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class StationCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var stationTitleLabel: UILabel!
    @IBOutlet weak var stationFuelProviderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
