//
//  Message_TableViewCell.swift
//  SheDistrict
//
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Message_TableViewCell: UITableViewCell {
    @IBOutlet weak var btn_select:UIButton!
    @IBOutlet weak var img_user_profile:UIImageView!
    @IBOutlet weak var lbl_user_name:UILabel!
    @IBOutlet weak var lbl_last_message:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }

}


