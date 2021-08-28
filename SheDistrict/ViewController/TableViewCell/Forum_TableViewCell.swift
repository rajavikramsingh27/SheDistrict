//
//  Forum_TableViewCell.swift
//  SheDistrict
//
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Forum_TableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_topics:UILabel!
    @IBOutlet weak var view_topics:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
