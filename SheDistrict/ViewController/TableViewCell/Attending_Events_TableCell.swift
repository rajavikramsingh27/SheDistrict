//  Attending_Events_TableCell.swift
//  SheDistrict
//  Created by appentus on 1/9/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Attending_Events_TableCell: UITableViewCell {
    @IBOutlet weak var btn_arrow:UIButton!
    @IBOutlet weak var btn_select:UIButton!
    @IBOutlet weak var view_details_container:UIView!
    
    @IBOutlet weak var imgProfileUser:UIImageView!
    @IBOutlet weak var lblText:UILabel!
    @IBOutlet weak var lbl_attended:UILabel!
    @IBOutlet weak var lblWeVeBeenVeryGoodInternet:UILabel!
    @IBOutlet weak var lblLocation:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
