//  Verify_YourSelf_VC.swift
//  SheDistrict
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import AVKit
import KRProgressHUD

class Verify_YourSelf_Camera_VC: UIViewController {
    @IBOutlet weak var btn_cancel:UIButton!
    @IBOutlet weak var img_cancel:UIImageView!
    @IBOutlet weak var btn_submit:UIButton!
    @IBOutlet weak var view_selected_image:UIView!
    @IBOutlet weak var img_selected:UIImageView!
    
    @IBOutlet weak var height_camera_view:NSLayoutConstraint!
    
    
    
    // MARK: Local Variables
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
//    var backCamera = AVCaptureDevice.default(for: AVMediaType.video)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_cancel.image = UIImage (named: "cancel-green")
        img_cancel.layer.cornerRadius = 10
        img_cancel.clipsToBounds = true
        btn_cancel("")
        height_camera_view.constant = 0
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            func_capture_session()
        }
        
        if user_bio_image != nil {
            view_selected_image.isHidden = false
            height_camera_view.constant = view_selected_image.bounds.width
            
            img_selected.image = user_bio_image
            previewLayer?.isHidden = true
            img_selected.isHidden = false
            btn_cancel.isHidden = false
            img_cancel.isHidden = false
            func_set_shadow_submit()
        }
        
    }
    
    @IBAction func btn_cancel (_ sender:Any) {
        height_camera_view.constant = 0
        
        view_selected_image.isHidden = true
        btn_cancel.isHidden = true
        img_cancel.isHidden = true
        func_remove_shadow_submit()
    }
    
    @IBAction func btn_submit (_ sender:Any) {
        is_camera_bio = true
        user_bio_image = img_selected.image
        
        let parameters = [
            "user_id":signUp!.userID,
            "user_bio":user_bio_text,
            "user_intro":"",
            "user_bio_video":"",
            "profile":""
        ]
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        let data = user_bio_image.jpegData(compressionQuality: 0.2)
        APIFunc.postAPI_Image("create_profile", data, parameters, "user_bio_video") { (json,status,message) in
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
                            self.funcVerificationSuccessfully()
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
    
    @IBAction func func_ChooseImage(_ sender:UIButton) {
        view_selected_image.isHidden = false
        height_camera_view.constant = view_selected_image.bounds.width
        
        if sender.currentTitle == "Camera" {
            sender.setTitle("Click Photo",for:.normal)
            previewLayer?.isHidden = false
            self.img_selected.isHidden = true
        } else if sender.currentTitle == "Click Photo" {
            sender.setTitle("Retake Photo",for:.normal)
            cameraDidTap(sender)
        } else if sender.currentTitle == "Retake Photo" {
            sender.setTitle("Click Photo",for:.normal)
            
            previewLayer?.isHidden = false
            self.img_selected.isHidden = true
        }
        
    }
    
    func func_set_shadow_submit() {
        btn_submit.isUserInteractionEnabled = true
        btn_submit.backgroundColor = hexStringToUIColor("47ECA5")
        btn_submit.layer.masksToBounds = false
        btn_submit.layer.cornerRadius = btn_submit.frame.height/2
        btn_submit.layer.shadowColor = hexStringToUIColor("47ECA5").cgColor
        btn_submit.layer.shadowPath = UIBezierPath(roundedRect:btn_submit.bounds, cornerRadius:btn_submit.layer.cornerRadius).cgPath
        btn_submit.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        btn_submit.layer.shadowOpacity = 0.5
        btn_submit.layer.shadowRadius = 6.0
    }
    
    func func_remove_shadow_submit() {
        btn_submit.isUserInteractionEnabled = false
        btn_submit.backgroundColor = hexStringToUIColor("CCCCCC")
        btn_submit.layer.shadowOpacity = 0.0
    }

}

// MARK:- Open Camera
extension Verify_YourSelf_Camera_VC {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        func_camera_permissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds: CGRect = view_selected_image.layer.bounds
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.bounds = bounds
        previewLayer!.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    @objc func func_camera_permissions() {
        func_camera_permission { (is_permission) in
            if is_permission {
                DispatchQueue.main.async {
                    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                        self.previewLayer!.frame = self.view_selected_image.bounds
                    }
                }
            }
        }
    }
    
    func func_camera_permission(completion:@escaping (Bool)->()) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                DispatchQueue.main.async {
                    let alert = UIAlertController (title: "Access camera!", message:"You need to go to settings to access camera", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "Cancel", style: .default) { (yes) in
                        
                    }
                    
                    let no = UIAlertAction(title: "Go to settings", style: .default) { (yes) in
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
    
    func func_capture_session() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                input = try AVCaptureDeviceInput(device: backCamera!)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera in simulator", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput!) {
                captureSession!.addOutput(stillImageOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer!.videoGravity = .resizeAspectFill
                previewLayer!.connection?.videoOrientation = .portrait
                previewLayer?.cornerRadius = 10
//                view_selected_image.layer.addSublayer(previewLayer!)
                self.view_selected_image.layer.addSublayer(self.previewLayer!)
                captureSession!.startRunning()
                previewLayer?.isHidden = false
            }
        }
    }
    
    @IBAction func cameraDidTap(_ sender:UIButton) {
        if let videoConnection = stillImageOutput?.connection(with: AVMediaType.video) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImage.Orientation.right)
                    
                    DispatchQueue.main.async {
                        self.img_selected.image = image
                        self.previewLayer?.isHidden = true
                        self.img_selected.isHidden = false
                        self.btn_cancel.isHidden = false
                        self.img_cancel.isHidden = false
                        self.func_set_shadow_submit()
                    }
                }
            })
        }
    }
    
}



extension Verify_YourSelf_Camera_VC:DelegateVerificationSuccessfully {
    func funcVerificationSuccessfully() {
         let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "Verification_Successfully_VC") as! Verification_Successfully_VC
         self.addChild(vc)
         vc.delegate = self
         vc.view.transform = CGAffineTransform(scaleX:2, y:2)
         
         self.view.addSubview(vc.view)
         UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
             vc.view.transform = .identity
         })
     }
        
    func func_DelegateVerificationCancel() {
        btn_back("")
    }
    
    
}
