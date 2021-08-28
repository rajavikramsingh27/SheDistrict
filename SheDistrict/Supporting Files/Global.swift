//  Common.swift
//  SheDistrict
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.



import Foundation
import UIKit



extension UIViewController {
    func func_Next_VC(_ identifier:String) {
        let storyboard_Main = UIStoryboard (name: "Main", bundle: nil)
        let vc = storyboard_Main.instantiateViewController(withIdentifier:identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func func_Next_VC_Main_1(_ identifier:String) {
        let storyboard_Main_1 = UIStoryboard (name: "Main_1", bundle: nil)
        let vc = storyboard_Main_1.instantiateViewController(withIdentifier:identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func func_Next_VC_Main_2(_ identifier:String) {
        let storyboard_Main_2 = UIStoryboard (name: "Main_2", bundle: nil)
        let vc = storyboard_Main_2.instantiateViewController(withIdentifier:identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func func_Next_VC_Main_3(_ identifier:String) {
        let storyboard_Main_3 = UIStoryboard (name: "Main_3", bundle: nil)
        let vc = storyboard_Main_3.instantiateViewController(withIdentifier:identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func func_Next_VC_Main_4(_ identifier:String) {
        let storyboard_Main_4 = UIStoryboard (name: "Main_4", bundle: nil)
        let vc = storyboard_Main_4.instantiateViewController(withIdentifier:identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_back(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func func_removeFromSuperview() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
        }) { (success) in
            self.view.removeFromSuperview()
        }
    }
    
    func func_attributed_text(_ color_1:UIColor,_ color_2:UIColor,_ font_1:UIFont,_ font_2:UIFont,_ text_1:String,_ text_2:String) -> NSAttributedString {
        let attrs1 = [NSAttributedString.Key.font:font_1, NSAttributedString.Key.foregroundColor:color_1]
        let attrs2 = [NSAttributedString.Key.font:font_2, NSAttributedString.Key.foregroundColor:color_2]
        
        let attributedString1 = NSMutableAttributedString(string:text_1, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:text_2, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
    
    func func_attributed_string(font_name:String,text:String,color:String) -> NSMutableAttributedString{
        let attrs11 = [NSAttributedString.Key.font:UIFont (name:font_name, size:16.0), NSAttributedString.Key.foregroundColor:hexStringToUIColor(color)]
        let attributedString11 = NSMutableAttributedString(string:text, attributes:attrs11)
        return attributedString11
    }
    
    func height_according_to_text(_ text:String, _ font:UIFont) -> CGFloat {
        let label = UILabel(frame:CGRect (x: 0, y: 0, width:self.view.bounds.width-40, height:.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightAccordingText(_ text:String, _ font:UIFont,_ width:CGFloat) -> CGFloat {
        let label = UILabel(frame:CGRect (x: 0, y: 0, width:width, height:.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func funcAlertController(_ message:String) {
        let alert_C = UIAlertController (title: message, message: "", preferredStyle: .alert)
        present(alert_C, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
            alert_C.dismiss(animated: true, completion: nil)
        }
    }
    
}



extension UIView {
    func func_error_shadow() {
        self.layer.masksToBounds = false
        //       self.layer.cornerRadius = view.frame.height/2
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.red.cgColor
    }
    
    func func_success_shadow() {
        self.layer.masksToBounds = false
        //        self.view.layer.cornerRadius = view.frame.height/2
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = hexStringToUIColor("9A9A9A").cgColor
    }
    
    func funcErrorShadowScheduleMetting() {
        self.backgroundColor = hexStringToUIColor("F9F9F9")
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.red.cgColor
    }
    
    func funcRemoveShadowScheduleMetting() {
        self.backgroundColor = hexStringToUIColor("F9F9F9").withAlphaComponent(0.7)
        self.layer.shadowOffset = CGSize(width: 0.0, height:0)
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowColor = hexStringToUIColor("9A9A9A").cgColor
    }
    
}



// MARK:- string
extension String {
    func height_According_Text(_ width: CGFloat,_ font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height:.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with:self)
    }
    
    func func_time_format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date_created = dateFormatter.date(from:self)
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: date_created ?? Date())
    }
    
    func bold(_ text:String) -> NSMutableAttributedString {
           let attrs1 = [NSAttributedString.Key.font:UIFont (name: "Roboto-Regular", size: 16)]
           let attrs2 = [NSAttributedString.Key.font:UIFont (name: "Roboto-Light", size: 16)]
           let attributedString1 = NSMutableAttributedString(string:self, attributes:attrs1 as [NSAttributedString.Key : Any])
           let attributedString2 = NSMutableAttributedString(string:text, attributes:attrs2 as [NSAttributedString.Key : Any])
           attributedString1.append(attributedString2)
           
           return attributedString1
       }
       
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func dateDifference() -> (month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let previous = dateFormatter.date(from: self)
        
        let day = Calendar.current.dateComponents([.day], from:Date(), to:previous!).day
        let month = Calendar.current.dateComponents([.month], from:Date(), to:previous!).month
        let hour = Calendar.current.dateComponents([.hour], from:Date(), to:previous!).hour
        let minute = Calendar.current.dateComponents([.minute], from:Date(), to:previous!).minute
        let second = Calendar.current.dateComponents([.second], from:Date(), to:previous!).second
        
        return (month:month!,day:day!,hour:hour!, minute:minute!,second:second!)
     }
    
    var dictionary:[String:Any] {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String:Any]
                return json!
            } catch {
                print("Something went wrong")
                return [:]
            }
        } else {
            return [:]
        }
    }
    
    var UTCToLocal:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from:self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
        
    var urlToImage:UIImage {
        let imgURL = URL (string:self)
        do {
            let imgData = try Data (contentsOf:imgURL!)
            return UIImage (data:imgData)!
        } catch {
            return k_default_user!
        }
        
    }
    
}



func hexStringToUIColor (_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// MARK:- AVKit
import AVKit
extension URL {
     func createVideoThumbnail() -> UIImage? {
        let asset = AVAsset(url:self)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = UIScreen.main.bounds.size
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options:.fragmentsAllowed)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
}



extension Array {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options:.fragmentsAllowed)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
}

