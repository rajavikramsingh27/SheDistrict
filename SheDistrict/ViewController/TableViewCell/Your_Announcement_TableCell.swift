
//
//  Your_Announcement_TableCell.swift
//  SheDistrict
//
//  Created by Appentus Technologies on 1/29/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Your_Announcement_TableCell: UITableViewCell {
    @IBOutlet weak var img_user_profile:UIImageView!
    @IBOutlet weak var lbl_user_name:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    @IBOutlet weak var btn_view:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
