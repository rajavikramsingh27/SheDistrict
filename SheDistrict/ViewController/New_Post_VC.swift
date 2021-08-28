//  New_Post_VC.swift
//  SheDistrict
//  Created by appentus on 1/7/20.
//  Copyright © 2020 appentus. All rights reserved.



import UIKit
import AVKit
import KRProgressHUD

class New_Post_VC: UIViewController {
    @IBOutlet weak var view_camera:UIView!
    @IBOutlet weak var img_selected:UIImageView!
    
    @IBOutlet weak var txt_choose_category:UITextField!
    @IBOutlet weak var txt_title:UITextField!
    @IBOutlet weak var txt_description:UITextView!
    
    @IBOutlet var view_post:[UIView]!
    
    let drop_down = DropDown()
    
    var k_Description = "Description"
    
    var is_repost = false
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_selected.layer.cornerRadius = 10
        img_selected.clipsToBounds = true
        
        if is_repost {
            func_repost()
        }
        
        func_post_category_API()
    }
        
    @IBAction func btn_upload_photo(_ sender:UIButton) {

        func_ChooseImage()
    }
    
    @IBAction func btn_preview(_ sender:UIButton) {
        if !func_validation() {
            return
        }
        
        let storyboard = UIStoryboard (name: "Main_1", bundle: nil)
        let preview_announcement = storyboard.instantiateViewController(withIdentifier: "Preview_Announcement_VC") as! Preview_Announcement_VC
        preview_announcement.arr_annoucement = [txt_title.text!,txt_choose_category.tag,img_selected.image!,txt_description.text!]
        self.navigationController?.pushViewController(preview_announcement, animated:true)
    }
    
    private func func_validation() -> Bool {
        var is_valid = false
        if !view_camera.isHidden {
            view_post[0].shake()
            view_post[0].func_error_shadow()
            is_valid = false
        } else if txt_choose_category.text!.isEmpty {
            view_post[1].shake()
            view_post[1].func_error_shadow()
            is_valid = false
        } else if txt_title.text!.isEmpty {
            view_post[2].shake()
            view_post[3].func_error_shadow()
            is_valid = false
        } else if txt_description.text!.isEmpty {
            view_post[2].shake()
            view_post[2].func_error_shadow()
            is_valid = false
        } else if txt_description.text! == k_Description {
            view_post[3].shake()
            view_post[3].func_error_shadow()
            is_valid = false
        } else {
            is_valid = true
        }
        
        return is_valid
    }
    
    func func_post_category_API() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.getAPI("post_category", [:]) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            postcategory = try decoder.decode([Postcategory].self, from: jsonData)
                            self.func_drop_down()
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
    
    func func_repost() {
        view_camera.isHidden = true
        img_selected.sd_setImage(with: URL(string:k_Base_URL_Imgae+get_details!.announcementImage), placeholderImage:nil)
        txt_choose_category.text = get_details?.category[0].categoryName
        txt_choose_category.tag = Int((get_details?.category[0].categoryID)!)!-1
        txt_title.text = get_details?.announcementTitle
        txt_description.text = get_details?.announcementDesc
        
        txt_description.textColor = UIColor .black
    }
    
    @IBAction func btn_submit(_ sender:UIButton) {
        self.view.endEditing(true)
        
        if !func_validation() {
            return
        }
        
        let param = [
            "user_id":signUp!.userID,
            "category_id":postcategory[txt_choose_category.tag].categoryID,
            "announcement_title":txt_title.text!,
            "announcement_desc":txt_description.text!
            ] as [String:String]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI_Image("add_announcement", img_selected.image!.jpegData(compressionQuality: 0.2), param, "image") { (json, status, message) in
            DispatchQueue.main.async {
                hud.dismiss()
                if status == success_resp {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        self.btn_Deleted_Message()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        hud.showError(withMessage: message)
                    }
                }
            }
        }
    }
    
}



extension New_Post_VC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func func_camera_permission(completion:@escaping (Bool)->()) {
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
    
    func func_ChooseImage() {
        for view in view_post {
            view.func_success_shadow()
        }
        
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
    
    func func_OpenCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate=self
            
            func_camera_permission { (is_permission) in
                if is_permission {
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
            }
        }  else {
            let alert  = UIAlertController(title: "Warning!", message: "You don't have camera in simulator", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func func_OpenGallary() {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate=self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            img_selected.image = pickedImage
            view_camera.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
}



import DropDown
extension New_Post_VC {
    func func_drop_down() {
        var arr_category_name = [String]()
        
        for category in postcategory {
            arr_category_name.append(category.categoryName)
        }
        
        drop_down.dismissMode = .manual
        drop_down.backgroundColor = UIColor.white
        
        drop_down.anchorView = txt_choose_category
        drop_down.bottomOffset = CGPoint(x: 0, y:txt_choose_category.bounds.height)
        drop_down.dataSource = arr_category_name
        
        drop_down.selectionAction = { [weak self] (index, item) in
            self?.txt_choose_category.tag = index
            self?.txt_choose_category.text = item
        }
    }
}


extension New_Post_VC:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        for view in view_post {
            view.func_success_shadow()
        }
        
        if textField == txt_choose_category  {
            drop_down.show()
            return false
        } else {
            return true
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txt_title == textField {
            if txt_title.text!.count < 40 {
                return true
            } else {
                if string == "" {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return true
        }
    }
    
    
    
}


extension New_Post_VC:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        for view in view_post {
            view.func_success_shadow()
        }
        
        if textView.text == k_Description {
            textView.textColor = UIColor .black
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = hexStringToUIColor("AEAEAE")
            textView.text = k_Description
        }
    }

}



extension New_Post_VC {
     func btn_Deleted_Message() {
        self.funcDeletedMessage("Your announcement", "has been ", "posted!")
    }
}

