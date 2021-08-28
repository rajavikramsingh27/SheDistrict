//  Record_Intro_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/4/20.
//  Copyright © 2020 appentus. All rights reserved.



import UIKit
import AVKit
import MobileCoreServices
import KRProgressHUD



class Record_Intro_ViewController: UIViewController {
    @IBOutlet weak var view_red_container:UIView!
    @IBOutlet weak var view_light_shadow:UIView!
    @IBOutlet weak var img_selected:UIImageView!
    @IBOutlet weak var btn_next:UIButton!
    @IBOutlet weak var view_recorded:UIView!
//    @IBOutlet weak var img_record:UIImageView!
    @IBOutlet weak var img_play_stop:UIImageView!
    @IBOutlet weak var view_record_property:UIView!
    @IBOutlet weak var height_record_property:NSLayoutConstraint!
    @IBOutlet weak var btn_play_pause:UIButton!
    
    //MARK:- custom camera
    @IBOutlet weak var lbl_record_time:UILabel!
    @IBOutlet weak var view_red:UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var viewVideoPlayer:UIView!
    
    @IBOutlet weak var lbl_camera_open:UILabel!
    @IBOutlet weak var topVideoPlayer:NSLayoutConstraint!
    
    
    
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
        
        view_record_property.isHidden = true
        view_recorded.isHidden = true
        view_red_container.isHidden = true
        view_record_property.isHidden = true
        height_record_property.constant = 0
        
        view_light_shadow.layer.cornerRadius = 10
        view_light_shadow.clipsToBounds = true
        img_selected.layer.cornerRadius = 10
        img_selected.clipsToBounds = true
        
        view_red.layer.cornerRadius = view_red.bounds.height/2
        view_red.clipsToBounds = true
        
        avCaptureVideoSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if user_intro != nil  {
            url_recorded = user_intro
            img_selected.image = url_recorded!.createVideoThumbnail()
            
            view_record_property.isHidden = false
            height_record_property.constant = 180
            
            func_add_video()
            func_remove_video()
        }
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        btn_play_pause.isHidden = true
        view_recorded.isHidden = true
        previewLayer.isHidden = true
        playerLayer.removeFromSuperlayer()
        lbl_record_time.isHidden = true
        
        record_time = 0
        if timer != nil {
            timer.invalidate()
        }
        
        func_remove_shadow_submit()
        func_remove_video()
        func_remove_video_property()
        
        lbl_camera_open.text = "Open Camera"
    }
    
    private func func_remove_video_property() {
        height_record_property.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.view_record_property.isHidden = true
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
        arr_create_profile_fields[1] = true
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



//MARK:- custom camera
extension Record_Intro_ViewController:AVCaptureFileOutputRecordingDelegate {
   private  func func_camera_permission(completion:@escaping (Bool)->()) {
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
    
    private func avCaptureVideoSetUp() {
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
        
    @IBAction func btn_play_pause (_ sender:UIButton) {
        btn_play_pause.isSelected = !btn_play_pause.isSelected
        if btn_play_pause.isSelected {
            player.pause()
            viewVideoPlayer.isHidden = true
        } else {
            player.play()
            viewVideoPlayer.isHidden = false
        }
    }
    
    @IBAction func btn_recordVideo(_ sender: UIButton) {
        viewVideoPlayer.isHidden = true
        
        if lbl_camera_open.text == "Open Camera" {
            lbl_camera_open.text = "Start Recording"
            func_add_video()
            
            topVideoPlayer.constant = 64
        } else if lbl_camera_open.text == "Start Recording" {
            lbl_camera_open.text = "Stop"
            
            movieOutput.stopRecording()
            func_remove_video_property()
            func_add_video()
            func_record_video()
            topVideoPlayer.constant = 64
        } else if lbl_camera_open.text == "Stop" {
            if record_time > 1 {
                lbl_camera_open.text = "Start Recording"
                func_remove_video()
                topVideoPlayer.constant = 0
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func func_add_video() {
        view_recorded.isHidden = false
        videoView.isHidden = false
        lbl_record_time.text = "0"
        
        view_red_container.isHidden = false
        lbl_record_time.isHidden = false
        view_red.isHidden = false
        
        previewLayer.isHidden = false
    }
    
    private func func_remove_video() {
        view_red_container.isHidden = true
        previewLayer.isHidden = true
        lbl_record_time.isHidden = true
        view_red.isHidden = true
        
        func_set_shadow_submit()
        movieOutput.stopRecording()
        
        record_time = 0
        
        if timer != nil {
            timer.invalidate()
        }
        
    }
    
    private func func_record_video() {
        timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(func_animationScaleEffect), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline:.now()+0.2) {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.mov")
            try? FileManager.default.removeItem(at: fileUrl)
            self.movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
        }
    }
    
    @IBAction func btn_play (_ sender:UIButton) {
        btn_play_pause.isHidden = false
        viewVideoPlayer.isHidden = false
        viewVideoPlayer.frame = videoView.frame
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
        
        view_record_property.isHidden = false
        height_record_property.constant = 180
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (completion) in
            
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!){
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
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
            lbl_camera_open.text = "Start Recording"
            
            func_set_shadow_submit()
            movieOutput.stopRecording()
            previewLayer.isHidden = true
            
            lbl_record_time.isHidden = true
            view_red.isHidden = true
            
            record_time = 0
            timer.invalidate()
        }
        
    }
    
}


