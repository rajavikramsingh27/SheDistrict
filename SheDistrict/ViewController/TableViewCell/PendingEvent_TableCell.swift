
//  PendingEvent_TableCell.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/10/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class PendingEvent_TableCell: UITableViewCell {
    @IBOutlet weak var imgUserProfile:UIImageView!
    @IBOutlet weak var lblUserNameInvited:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var btnView:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    
}
