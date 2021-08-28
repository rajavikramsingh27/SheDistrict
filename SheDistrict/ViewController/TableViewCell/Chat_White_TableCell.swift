//
//  Chat_White_TableCell.swift
//  SheDistrict
//
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Chat_White_TableCell: UITableViewCell {
    @IBOutlet weak var view_container:UIView!
    @IBOutlet weak var view_container_chat:UIView!
    
    @IBOutlet weak var img_user_profile:UIImageView!
    @IBOutlet weak var lbl_chat:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    @IBOutlet weak var lbl_sent:UILabel!
    
    @IBOutlet weak var img_chat:UIImageView!
    @IBOutlet weak var btn_image_chat:UIButton!
    @IBOutlet weak var view_video_chat:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
    
}
