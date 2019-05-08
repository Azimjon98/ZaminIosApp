//
//  Extension.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/23/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation
import SDWebImage

extension String{
    func trim() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func parseMyDate(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let todayMorning = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let newsDate: Date = dateFormatter.date(from: date) ?? Date()

        
        if todayMorning! < newsDate{
            dateFormatter.dateFormat = "HH:mm"
            let textToday = LanguageHelper.getString(stringId: .today)
            
            return dateFormatter.string(from: newsDate) +
                " • " + textToday + " • "
        } else {
            dateFormatter.dateFormat = "HH:mm • d "
            let year = Calendar.current.component(.year, from: newsDate)
            let month = Calendar.current.component(.month, from: newsDate)

            let textMonth = LanguageHelper.getArray(arrayId: .months)[month - 1]
            
            
            return dateFormatter.string(from: newsDate) +
                textMonth + " \(year)" + " • "
        }
        
    }
    
    static func parseMyCategoryName(id categoryId : String) ->  String{
        return "Dunyo"
    }
    
}

extension UIImageView{
    func load(url: String,withFixedSide: Bool = false) -> Void{
        if !withFixedSide{
            self.sd_setImage(with:URL(string: url), placeholderImage: UIImage(named: "empty_medium"))
        }else{
            self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "empty_medium"), options: .highPriority, completed: {
                (image, error, cacheType, url) in
                
                if error == nil, image != nil{
                    let imageWidth = image?.size.width
                    let imageHeight = image?.size.height
                    let ratio = imageHeight! / imageWidth!
                    print("loadImage: \(imageHeight)   \(imageWidth)")
                    print("loadImage: \(self.frame.height)   \(self.frame.width)")
                    print("loadImage: \(ratio)")
                    
                    self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.width * ratio)
//                    self.contentMode = .scaleAspectFill; // This determines position of image
                    self.clipsToBounds = true;
                    print("loadImageAfter: \(self.frame.height)   \(self.frame.width)")
                }
            })
        }
        
        
        
    }
    
    func changeColor(color: UIColor){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}

extension UIButton{
    func changeColor(color: UIColor){
        self.setImage(self.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = color
    }
    
}

extension String{
    static func myTitleAttributedString(text: String, spacing forVerticalSpacing: CGFloat = 4) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = forVerticalSpacing // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        // *** Set Attributed String to your label ***
        return attributedString
    }
}

extension UIViewController {
    func presentAlert(message: String) {
        if presentedViewController == nil {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

}


extension UserDefaults{
    
    static func getLocale() -> String {
        if let lang = UserDefaults.standard.string(forKey: Constants.KEY_LANG){
            if lang == "uz" {return "uz"}
            else if lang == "kr" {return "kr"}
        }
        
        return "uz"
    }
    
    static func setLocale(_ locale: String) {
        UserDefaults.standard.set(locale, forKey: Constants.KEY_LANG)
    }
}






extension UIViewController {
    
    func startTopProgress(topView: UIView, height: CGFloat, backColor: UIColor, frontColor: UIColor) {
        print("start Progress")
        let backView = UIView()
        backView.frame = CGRect(x: topView.frame.minX, y: topView.frame.minY, width: topView.frame.width, height: height)
        backView.backgroundColor = backColor
        let frontView = UIView()
        backView.addSubview(frontView)
        frontView.frame = CGRect(x: -120, y: 0, width: 120, height: height)
        
        frontView.backgroundColor = frontColor
//        if let _ = self.view.viewWithTag(1010101){
//            return
//        }else{
//
//        }
        self.view.addSubview(backView)
        backView.tag = 1010101
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat], animations: {
            frontView.frame = CGRect(x: backView.frame.maxX, y: 0, width: 136, height: height)
            
        })
    }
    
    func stopTopProgress(){
        self.view.viewWithTag(1010101)?.removeFromSuperview()
    }
}




extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1, section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
