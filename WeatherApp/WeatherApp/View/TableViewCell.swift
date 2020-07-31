//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Tom Nguyen on 7/13/20.
//  Copyright © 2020 tomnguyen. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var cityName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
