//  Record_Write_Intro_VC.swift
//  SheDistrict
//  Created by appentus on 1/4/20.
//  Copyright © 2020 appentus. All rights reserved.

import UIKit
import AVKit
import MobileCoreServices
import KRProgressHUD


class Record_Write_Intro_VC: UIViewController {
    @IBOutlet weak var txt_write_bio:UITextView!
    @IBOutlet weak var view_light_shadow:UIView!
    @IBOutlet weak var img_selected:UIImageView!
    @IBOutlet weak var btn_next:UIButton!
    @IBOutlet weak var view_recorded:UIView!
    @IBOutlet weak var height_recorded_view:NSLayoutConstraint!
    @IBOutlet weak var top_recorded_view:NSLayoutConstraint!
    
    //MARK:- custom camera
    
    @IBOutlet weak var lbl_record_time:UILabel!
    @IBOutlet weak var view_red:UIView!
    @IBOutlet weak var view_red_container:UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var lbl_recordVideo:UILabel!
    
    @IBOutlet weak var btn_play_pause:UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_play_pause.isHidden = true
        
        view_recorded.isHidden = true
        height_recorded_view.constant = 0
        top_recorded_view.constant = 54
        
        func_show_animation()
        
        view_light_shadow.layer.cornerRadius = 10
        view_light_shadow.clipsToBounds = true
        img_selected.layer.cornerRadius = 10
        img_selected.clipsToBounds = true
        
        view_red.layer.cornerRadius = view_red.bounds.height/2
        view_red.clipsToBounds = true
        view_red_container.isHidden = true
        avCaptureVideoSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !user_bio_text.isEmpty {
            txt_write_bio.text = user_bio_text
            txt_write_bio.textColor = UIColor .black
        }
        
        if user_intro != nil {
            url_recorded = user_intro
            img_selected.image = url_recorded!.createVideoThumbnail()
            
            let btn = UIButton()
            btn_add_camera(btn)
            
            lbl_recordVideo.text = "Start Recording"
            top_recorded_view.constant = 0
            func_show_animation()
            
            func_set_shadow_submit()
            movieOutput.stopRecording()
            
            previewLayer.isHidden = true
            lbl_record_time.isHidden = true
            view_red.isHidden = true
            view_red_container.isHidden = true
            
            record_time = 0
        }
        
    }
    
    @IBAction func btn_cancel (_ sender:UIButton) {
        btn_play_pause.isHidden = true
        func_remove_shadow_submit()
        view_red_container.isHidden = true
        
        lbl_recordVideo.text = "Open Camera"
        
        movieOutput.stopRecording()
        previewLayer.isHidden = true
        record_time = 0
        
        height_recorded_view.constant = 0
        top_recorded_view.constant = 55
        func_show_animation()
        
        view_recorded.isHidden = true
    }
    
    private func func_show_animation() {
        UIView.animate(withDuration:0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
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
        arr_create_profile_fields[3] = true
        if txt_write_bio.text!.isEmpty || txt_write_bio.text == "Write a couple of things that about you..." {
            user_bio_text = ""
        } else {
            user_bio_text = txt_write_bio.text!
        }
        
        user_intro = url_recorded
        
        let parameters = [
            "user_id":signUp!.userID,
            "user_bio":user_bio_text,
            "user_bio_image":"",
            "user_bio_video":"",
            "profile":""
        ]
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        
        var data_user_intro:Data!
        
        do {
            data_user_intro = try Data (contentsOf:user_intro)
        } catch {
            print(error.localizedDescription)
        }
        
        APIFunc.postAPI_Video("create_profile",data_user_intro, parameters,"user_intro") { (json,status,message) in
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
                            self.btn_back(sender)
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
    
}

extension Record_Write_Intro_VC:UITextViewDelegate{
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


//MARK:- custom camera
extension Record_Write_Intro_VC:AVCaptureFileOutputRecordingDelegate {
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
    
    func avCaptureVideoSetUp() {
        if let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] {
            for device in devices {
                if device.hasMediaType(AVMediaType.video) {
                    if device .position == AVCaptureDevice.Position.front{
                        videoCaptureDevice = device
                    }
                }
            }
            
            if videoCaptureDevice != nil {
                do {
                    // Add Video Input
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: videoCaptureDevice!))
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
    
    @IBAction func btn_open_camera(_ sender: UIButton) {
        viewVideoPlayer.isHidden = true
        
        if lbl_recordVideo.text == "Open Camera" {
            lbl_recordVideo.text = "Start Recording"
            
            DispatchQueue.main.asyncAfter(deadline:.now()+0.2) {
                self.btn_add_camera(sender)
            }
        } else if lbl_recordVideo.text == "Start Recording" {
            lbl_recordVideo.text = "Stop"
            
            DispatchQueue.main.asyncAfter(deadline:.now()+0.1) {
                self.btn_add_camera(sender)
                self.func_record()
            }
        } else if lbl_recordVideo.text == "Stop" {
            if record_time > 1 {
                lbl_recordVideo.text = "Start Recording"
                top_recorded_view.constant = 0
                func_show_animation()
                
                func_set_shadow_submit()
                movieOutput.stopRecording()
                
                previewLayer.isHidden = true
                lbl_record_time.isHidden = true
                view_red.isHidden = true
                view_red_container.isHidden = true
                
                record_time = 0
                timer.invalidate()
            }
        }
        
    }
    
    @IBAction func btn_add_camera(_ sender: UIButton) {
        height_recorded_view.constant = view_recorded.bounds.width
        func_show_animation()
        
        func_show_video()
        
        lbl_record_time.text = "0"
        record_time = 0
        
        videoView.isHidden = false
        lbl_record_time.isHidden = false
        view_red.isHidden = false
        view_red_container.isHidden = false
        previewLayer.isHidden = false
        
    }
    
    func func_show_video() {
        view_recorded.isHidden = false
    }
    
    func func_record() {
        timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(func_animationScaleEffect), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline:.now()+0.1) {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.mov")
            try? FileManager.default.removeItem(at: fileUrl)
            self.movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
        }
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
    
    @objc func func_animationScaleEffect() {
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
            lbl_recordVideo.text = "Start Recording"
            
            func_set_shadow_submit()
            movieOutput.stopRecording()
            previewLayer.isHidden = true
            
            lbl_record_time.isHidden = true
            view_red.isHidden = true
            view_red_container.isHidden = true
            
            record_time = 0
            timer.invalidate()
        }
    }
    
}


