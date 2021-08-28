//  ViewController.swift
//  SheDistrict
//  Created by appentus on 1/1/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import SwiftyJSON


class Splash_ViewController: UIViewController {
    @IBOutlet weak var progress_view:UIProgressView!
    @IBOutlet weak var coll_loading_content:UICollectionView!
    
    let arr_loading_content = ["Patience is key! We’re a brand new app, so it’ll look a little like ghost town here. Thank you for helping us fill the community!",
                               "Do you have any feedback, questions, or concerns? Please reach out to us to help make us better!"]
//                               "Check out the forum for cool discussion, the latest gossip, and more"]
    
    var index = Float(1)
    var timer:Timer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progress_view.setProgress(0.0, animated: true)
        startTimer()
    }
    
    
    
    func func_Go_Next_VC() {
        DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
            
            if let data_1 = UserDefaults.standard.object(forKey: k_user_detals) {
                let json = JSON(data_1)
                print(json)
                
                let decoder = JSONDecoder()
                if let jsonData = json[result_resp].description.data(using: .utf8) {
                    do {
                        signUp = try decoder.decode(SignUp.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.func_Next_VC_Main_1("TabBar_SheDistrict")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                self.func_Next_VC("Login_Option_ViewController")
            }
        })
    }
    
}



extension Splash_ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_loading_content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath)
        
        let lbl_content = cell.viewWithTag(1) as! UILabel
        lbl_content.text = arr_loading_content[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let coll_bounds = collectionView.bounds
        return CGSize (width:coll_bounds.width, height:coll_bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func scrollToNextCell() {
        index = index+1
        progress_view.setProgress(index/3, animated: true)
        
        if index > 3 {
            timer.invalidate()
            
            self.func_Go_Next_VC()
        }
        
        let coll_bounds = coll_loading_content.bounds
        let contentOffset = coll_loading_content.contentOffset;
        let rect = CGRect (x:contentOffset.x + coll_bounds.width, y: contentOffset.y, width:coll_bounds.width, height:coll_bounds.height)
        coll_loading_content.scrollRectToVisible(rect, animated: true);
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval:2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    
    
}

