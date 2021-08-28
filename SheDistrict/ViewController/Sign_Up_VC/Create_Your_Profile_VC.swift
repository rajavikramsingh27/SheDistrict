//  Create_Your_Profile_VC.swift
//  SheDistrict
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import AVKit
import KRProgressHUD
import SDWebImage


var arr_create_profile_fields = [Bool]()
var user_intro:URL!
var user_bio_text = ""
var user_bio_image:UIImage!
var user_bio_video:URL!


class Create_Your_Profile_VC: UIViewController {
    @IBOutlet var view_arr:[UIView]!
    @IBOutlet weak var btn_select_image:UIButton!
    @IBOutlet weak var img_arrow:UIImageView!
    @IBOutlet weak var lbl_add_profle_photo:UILabel!
    @IBOutlet weak var img_select_image:UIImageView!
    
    var isEditProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_select_image.layer.cornerRadius = btn_select_image.bounds.height/2
        btn_select_image.clipsToBounds = true
        
        img_arrow.isHidden = true
        lbl_add_profle_photo.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.img_arrow.isHidden = false
            self.lbl_add_profle_photo.isHidden = false
            self.func_set_animation_cloud()
        }
        
        arr_create_profile_fields.removeAll()
        for _ in 0..<4 {
            arr_create_profile_fields.append(false)
        }
        
        if !(signUp?.userProfile.isEmpty)! {
            btn_select_image.setImage(UIImage(named:""), for:.normal)
            btn_select_image.imageEdgeInsets = UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
            img_select_image.sd_setImage(with: URL(string:k_Base_URL_Imgae+signUp!.userProfile), placeholderImage:nil)
            
            arr_create_profile_fields[0] = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if arr_create_profile_fields.count > 0 {
            if arr_create_profile_fields[1] && arr_create_profile_fields[2] {
                arr_create_profile_fields[3] = true
            } else if arr_create_profile_fields[3] {
                arr_create_profile_fields[1] = true
                arr_create_profile_fields[2] = true
            }
        }
        for i in 0..<view_arr.count {
            view_arr[i].func_success_shadow()
        }
    }
    
    private func func_set_animation_cloud() {
        let transition:CATransition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        img_arrow.layer.add(transition, forKey: kCATransition)
        
        lbl_add_profle_photo.transform = CGAffineTransform(scaleX:2, y:2)
        lbl_add_profle_photo.isHidden = false
        
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.lbl_add_profle_photo.transform = .identity
        })
    }
    
    @IBAction func btn_next(_ sender:UIButton) {
        if !func_validation() {
            return
        }
        
        let parameters = [
            "user_id":signUp!.userID,
            "user_bio":user_bio_text,
            "user_intro":"",
            "user_bio_video":"",
            "user_bio_image":""
        ]
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        let data = img_select_image.image!.jpegData(compressionQuality: 0.2)
        APIFunc.postAPI_Image("create_profile", data, parameters, "profile") { (json,status,message)  in
            DispatchQueue.main.async {
                hud.dismiss()
                if json.dictionaryObject == nil {
                    return
                }
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            signUp = try decoder.decode(SignUp.self, from: jsonData)
                            do {
                                let data = try json.rawData()
                                UserDefaults.standard.setValue(data, forKey: k_user_detals)
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            if self.isEditProfile {
                                self.navigationController?.popViewController(animated:true)
                            } else {
                                self.func_Next_VC("Upload_Photos_VC")
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .fail:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        hud.showError(withMessage: "\(json["message"])")
                    })
                case .error_from_api:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        hud.showError(withMessage:"error_message")
                    })
                }
            }
        }
        
    }
    
    @IBAction func btn_record_intro(_ sender:UIButton) {
        func_Next_VC("Record_Intro_ViewController")
    }
    
    @IBAction func btn_write_bio(_ sender:UIButton) {
        func_Next_VC("Write_Bio_ViewController")
    }
    
    @IBAction func btn_do_both(_ sender:UIButton) {
        func_Next_VC_Main_1("Record_Write_Intro_VC")
    }
    
    private func func_validation() -> Bool {
        var is_valid = false
        
        for i in 0..<view_arr.count {
            if !arr_create_profile_fields[i] {
                view_arr[i].shake()
                view_arr[i].func_error_shadow()
                
                is_valid = false
                break
            } else {
                view_arr[i].func_success_shadow()
                is_valid = true
            }
        }
        
        return is_valid
    }
        
}



extension Create_Your_Profile_VC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func func_camera_permission(completion:@escaping (Bool)->()) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                DispatchQueue.main.async {
                    let alert = UIAlertController (title: "SheDistrict would like to access the camera", message: "SheDistrict needs Camera and PhotoLibrary to complete you profile", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "Don't allow", style: .default) { (yes) in
                        
                    }
                    
                    let no = UIAlertAction(title: "Allow", style: .default) { (yes) in
                        DispatchQueue.main.async {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }
                    
                    alert.addAction(yes)
                    alert.addAction(no)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            completion(granted)
        }
    }
    
    @IBAction func func_ChooseImage(_ sender:UIButton) {
        let alert = UIAlertController(title: "", message: "Please select!", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            DispatchQueue.main.async {
                self.func_OpenCamera()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default , handler:{ (UIAlertAction)in
            DispatchQueue.main.async {
                self.func_OpenGallary()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func func_OpenCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            func_camera_permission { (is_permission) in
                if is_permission {
                    DispatchQueue.main.async {
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert  = UIAlertController(title: "Warning!", message: "You don't have camera in simulator", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func func_OpenGallary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate=self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            btn_select_image.setImage(UIImage(named:""), for:.normal)
            btn_select_image.imageEdgeInsets = UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
            img_select_image.image = pickedImage
            
            arr_create_profile_fields[0] = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}



