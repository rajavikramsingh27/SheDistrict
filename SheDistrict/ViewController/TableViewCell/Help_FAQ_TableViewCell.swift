//
//  Help_FAQ_TableViewCell.swift
//  SheDistrict
//
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Help_FAQ_TableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_faq_title:UILabel!
    @IBOutlet weak var lbl_faq_description:UILabel!
    @IBOutlet weak var btnUpDown:UIButton!
    
    @IBOutlet weak var height_faq_title:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }
    
    

}
