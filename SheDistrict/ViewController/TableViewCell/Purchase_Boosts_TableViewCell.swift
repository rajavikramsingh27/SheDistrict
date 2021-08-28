//
//  Purchase_Boosts_TableViewCell.swift
//  SheDistrict
//
//  Created by appentus on 1/18/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Purchase_Boosts_TableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_boosts:UILabel!
    @IBOutlet weak var lbl_price:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
