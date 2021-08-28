//  Write_Bio_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.



import UIKit
import AVKit
import MobileCoreServices



var is_camera_bio = false
var is_video_bio = false



class Write_Bio_ViewController: UIViewController {
    @IBOutlet weak var txt_write_bio:UITextView!
    @IBOutlet weak var view_verification_successfull:UIView!
    @IBOutlet weak var stack_bio_option:UIStackView!
    
    @IBOutlet weak var view_why_am_i_seeing:UIView!
    @IBOutlet weak var btn_next:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        is_camera_bio = false
        is_video_bio = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        func_remove_shadow_submit()
        
        if !user_bio_text.isEmpty {
            txt_write_bio.text = user_bio_text
            txt_write_bio.textColor = UIColor .black
        }
        
        if is_camera_bio && is_video_bio {
            stack_bio_option.isHidden = true
            view_verification_successfull.isHidden = false
            
            func_set_shadow_submit()
        } else {
            stack_bio_option.isHidden = false
            view_verification_successfull.isHidden = true
        }
    }
    
   @IBAction func btn_why_am_i_seeing(_ sender:UIButton) {
        view_why_am_i_seeing.frame = CGRect (x: 0, y: 0, width:self.view.bounds.width, height: self.view.bounds.height)
        
        self.view.addSubview(view_why_am_i_seeing)
    }
    
    @IBAction func btn_cancel_why_am_i_seeing(_ sender:UIButton) {
        view_why_am_i_seeing.removeFromSuperview()
    }
    
    @IBAction func btn_take_picture(_ sender:UIButton) {
        func_Next_VC("Verify_YourSelf_Camera_VC")
    }
    
    @IBAction func btn_record_video(_ sender:UIButton) {
        func_Next_VC("Verify_YourSelf_Video_VC")
    }
    
//    @IBAction func btn_next(_ sender:UIButton) {
//        func_Next_VC("Upload_Photos_VC")
//    }
    
    private func func_set_shadow_submit() {
        btn_next.isUserInteractionEnabled = true
        btn_next.backgroundColor = hexStringToUIColor("47ECA5")
        btn_next.layer.masksToBounds = false
        btn_next.layer.cornerRadius = btn_next.frame.height/2
        btn_next.layer.shadowColor = hexStringToUIColor("47ECA5").cgColor
        btn_next.layer.shadowPath = UIBezierPath(roundedRect:btn_next.bounds, cornerRadius:btn_next.layer.cornerRadius).cgPath
        btn_next.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        btn_next.layer.shadowOpacity = 0.5
        btn_next.layer.shadowRadius = 6.0
    }
    
    private func func_remove_shadow_submit() {
        btn_next.isUserInteractionEnabled = false
        btn_next.backgroundColor = hexStringToUIColor("CCCCCC")
        btn_next.layer.shadowOpacity = 0.0
    }
    
    @IBAction func btn_next (_ sender:UIButton) {
        arr_create_profile_fields[2] = true
        if txt_write_bio.text!.isEmpty || txt_write_bio.text == "Write a couple of things that about you..." {
            user_bio_text = ""
        } else {
            user_bio_text = txt_write_bio.text!
        }
        
        btn_back(sender)
    }
    
}



extension Write_Bio_ViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text! == "Write a couple of things that about you..." {
            textView.text = ""
            textView.textColor = UIColor .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text! == "" {
            textView.text = "Write a couple of things that about you..."
            textView.textColor = UIColor .lightGray
        }
    }
    
}

