//
//  StatisticsCell.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 07.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class StatisticsCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var stationTitleLabel: UILabel!
    @IBOutlet weak var litresLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
