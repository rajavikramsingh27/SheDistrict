//  Verify_YourSelf_Video_VC.swift
//  SheDistrict
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import MobileCoreServices
import AVKit
import KRProgressHUD



class Verify_YourSelf_Video_VC: UIViewController {
    @IBOutlet weak var img_cancel:UIImageView!
    @IBOutlet weak var btn_cancel:UIButton!
    @IBOutlet weak var btn_submit:UIButton!
    @IBOutlet weak var img_selected:UIImageView!
    
    @IBOutlet weak var btn_recordVideo:UIButton!
    @IBOutlet weak var lbl_record_time:UILabel!
    @IBOutlet weak var view_red:UIView!
    @IBOutlet weak var top_record_view:NSLayoutConstraint!
    @IBOutlet weak var btn_play_pause:UIButton!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var height_camera:NSLayoutConstraint!
    
    @IBOutlet weak var viewVideoPlayer:UIView!

    
    var player:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var url_recorded:URL!
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var movieOutput = AVCaptureMovieFileOutput()
    var videoCaptureDevice : AVCaptureDevice?
    
    var timer:Timer!
    var record_time = 0
    
    var is_cancel_first_time = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_selected.layer.cornerRadius = 10
        img_selected.clipsToBounds = true
        func_set_UI()
        
        avCaptureVideoSetUp()
        func_animationScaleEffect()
        func_hide_record_details()
        
//        top_record_view.constant = 64
        func_setheight_recordview(64)
        func_setheight_camera(0)
        
        btn_play_pause.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if user_bio_video != nil {
            url_recorded = user_bio_video
            img_selected.image = url_recorded!.createVideoThumbnail()
            
            let btn = UIButton()
            btn_add_camera(btn)
            func_remove_video()
            btn_cancel.isHidden = false
            img_cancel.isHidden = false
        }
    }
    
    @IBAction func btn_submit(_ sender:Any) {
        is_video_bio = true
        user_bio_video = url_recorded
        
        let parameters = [
            "user_id":signUp!.userID,
            "user_bio":user_bio_text,
            "user_bio_image":"",
            "user_intro":"",
            "profile":""
        ]
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        
        var data:Data!
        
        do {
            data = try Data (contentsOf:user_bio_video)
        } catch {
            print(error.localizedDescription)
        }
        APIFunc.postAPI_Video("create_profile",data, parameters,"user_bio_video") { (json,status,message) in
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
    
    
    
    @IBAction func btn_cancel (_ sender:Any) {
        btn_play_pause.isHidden = true
        func_setheight_camera(0)
        btn_recordVideo.setTitle("Record", for: .normal)
        movieOutput.stopRecording()
        
        func_remove_shadow_submit()
        view_red.isHidden = true
        lbl_record_time.isHidden = true
        
//        if player != nil {
//            player.pause()
//        }
        
        UIView.animate(withDuration:0.1, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0, options: [], animations: {
            self.videoView.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
            self.btn_cancel.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
            self.img_cancel.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
        }) { (success) in
            self.videoView.isHidden = true
            self.btn_cancel.isHidden = true
            self.img_cancel.isHidden = true
        }
    }
    
    func func_set_UI() {
        btn_play_pause.isHidden = true
        func_setheight_camera(0)
        btn_recordVideo.setTitle("Record", for: .normal)
        movieOutput.stopRecording()
        
        func_remove_shadow_submit()
        
        view_red.isHidden = true
        self.videoView.isHidden = true
        self.btn_cancel.isHidden = true
        self.img_cancel.isHidden = true
    }
    
    private func func_setheight_camera(_ size:CGFloat) {
        height_camera.constant = size
        
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func func_setheight_recordview(_ size:CGFloat) {
        top_record_view.constant = size
        
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func func_set_shadow_submit() {
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
    
    private func func_remove_shadow_submit() {
        btn_submit.isUserInteractionEnabled = false
        btn_submit.backgroundColor = hexStringToUIColor("CCCCCC")
        btn_submit.layer.shadowOpacity = 0.0
    }
    
    private func func_hide_record_details() {
        view_red.isHidden = true
        lbl_record_time.isHidden = true
    }
    
    private func func_show_record_details() {
        view_red.layer.cornerRadius = view_red.bounds.height/2
        view_red.clipsToBounds = true
        
        view_red.isHidden = false
        lbl_record_time.isHidden = false
    }
    
    @objc private func func_animationScaleEffect() {
        record_time += 1
        lbl_record_time.text = "\(record_time)"
        
        UIView.animate(withDuration:1.0, animations: {
            self.view_red.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }) { (completion) in
            UIView.animate(withDuration: 1.0, animations: {
                self.view_red.transform = CGAffineTransform(scaleX:1, y:1)
            })
        }
        
        if record_time > 60 {
            is_video_bio = true
            func_set_shadow_submit()
            
            func_setheight_recordview(0)
            movieOutput.stopRecording()
            
            previewLayer.isHidden = true
            
            btn_recordVideo.setTitle("Start Recording", for: .normal)
            func_hide_record_details()
            lbl_record_time.text = "0"
            record_time = 0
            timer.invalidate()
        }
    }
    
}



extension Verify_YourSelf_Video_VC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    
}



extension Verify_YourSelf_Video_VC:AVCaptureFileOutputRecordingDelegate {
    private func avCaptureVideoSetUp() {
        if let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] {
            for device in devices {
                if device.hasMediaType(AVMediaType.video) {
                    if device .position == AVCaptureDevice.Position.front {
                        videoCaptureDevice = device
                    }
                }
            }
            
            if videoCaptureDevice != nil {
                do {
                    // Add Video Input
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: videoCaptureDevice!))
                    // Get Audio Device
                    
                    let audioInput = AVCaptureDevice .default(for:AVMediaType.audio)
                    
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: audioInput!))
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.videoView.layer.addSublayer(self.previewLayer)
                    previewLayer.cornerRadius = 10
                    
                    self.captureSession.addOutput(self.movieOutput)
                    captureSession.startRunning()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds: CGRect = videoView.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.bounds = bounds
        previewLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    @IBAction func btn_recordVideo(_ sender: UIButton) {
        viewVideoPlayer.isHidden = true
        
        if sender.currentTitle == "Record" {
            sender.setTitle("Start Recording", for: .normal)
            
            func_show_video()
            DispatchQueue.main.asyncAfter(deadline:.now()+0.15) {
                self.btn_add_camera(sender)
                self.func_show_record_details()
            }
        } else if sender.currentTitle == "Start Recording" {
            sender.setTitle("Stop", for: .normal)
            
//            func_remove_video()
            DispatchQueue.main.asyncAfter(deadline:.now()+0.1) {
                self.func_record()
            }
        } else if sender.currentTitle == "Stop" {
            if record_time > 1 {
                sender.setTitle("Start Recording", for: .normal)
                func_remove_video()
            }
        }
        
    }
    
    @IBAction func btn_add_camera(_ sender: UIButton) {
//        top_record_view.constant = 64
        func_setheight_recordview(64)
        func_setheight_camera(videoView.bounds.width)
        previewLayer.isHidden = false
        videoView.isHidden = false
        lbl_record_time.text = "0"
        func_show_record_details()
        
        movieOutput.stopRecording()
        record_time = 0
        if timer != nil {
            timer.invalidate()
        }
        
    }
    
    private func func_show_video() {
        videoView.transform = CGAffineTransform(scaleX:2, y:2)
        btn_cancel.transform = CGAffineTransform(scaleX:2, y:2)
        img_cancel.transform = CGAffineTransform(scaleX:2, y:2)
        
        videoView.isHidden = false
        btn_cancel.isHidden = false
        img_cancel.isHidden = false
        
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.videoView.transform = .identity
            self.btn_cancel.transform = .identity
            self.img_cancel.transform = .identity
        })
    }
    
    private func func_record() {
        timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(func_animationScaleEffect), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline:.now()+0.1) {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.mov")
            try? FileManager.default.removeItem(at: fileUrl)
            self.movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
        }
    }
    
    private func func_remove_video() {
        is_video_bio = true
        lbl_record_time.text = "0"
        record_time = 0
        func_setheight_recordview(0)
        movieOutput.stopRecording()
        previewLayer.isHidden = true
        
        func_hide_record_details()
        func_set_shadow_submit()
    }
     
    @IBAction func btn_play (_ sender:UIButton) {
        btn_play_pause.isHidden = false
        viewVideoPlayer.isHidden = false
        viewVideoPlayer.frame = CGRect (x: 0, y: 0, width:videoView.bounds.width, height:videoView.bounds.height)
        
        player = AVPlayer(url:url_recorded!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = CGRect (x:0, y:0, width:viewVideoPlayer.bounds.width, height:viewVideoPlayer.bounds.height)
        viewVideoPlayer.layer.insertSublayer(playerLayer, below: viewVideoPlayer.layer)
        viewVideoPlayer.layer.cornerRadius = 10
        viewVideoPlayer.clipsToBounds = true
        
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @IBAction func btn_play_pause (_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            player.pause()
            viewVideoPlayer.isHidden = true
        } else {
            player.play()
            viewVideoPlayer.isHidden = false
        }
    }
    
    @objc fileprivate func playerItemReachedEnd() {
        btn_play_pause.isHidden = true
        player.seek(to:CMTime.zero)
        playerLayer.removeFromSuperlayer()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        url_recorded = outputFileURL
        
        img_selected.image = outputFileURL.createVideoThumbnail()
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!){
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
        
}



extension Verify_YourSelf_Video_VC:DelegateVerificationSuccessfully {
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
