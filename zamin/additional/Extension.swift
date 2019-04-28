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

        let lang = UserDefaults.standard.string(forKey: Constants.KEY_LANG) ?? "oz"
        if todayMorning! < newsDate{
            dateFormatter.dateFormat = "HH:mm"
            let textToday = (lang == "oz") ? LanguageHelper.UZStrings.today.toString() :
                LanguageHelper.KRStrings.today.toString()
            
            return dateFormatter.string(from: newsDate) +
                " • " + textToday + " • "
        } else {
            dateFormatter.dateFormat = "HH:mm • d "
            let year = Calendar.current.component(.year, from: newsDate)
            let month = Calendar.current.component(.month, from: newsDate)
            let textMonth = (lang == "oz") ? LanguageHelper.shared.monthsUZ[month - 1] :
                LanguageHelper.shared.monthsKR[month - 1]

            
            return dateFormatter.string(from: newsDate) +
                textMonth + " \(year)" + " • "
        }
        
    }
    
    static func parseMyCategoryName(id categoryId : String) ->  String{
        return "Dunyo"
    }
    
}

extension UIImageView{
    func load(url: String) -> Void{
        self.sd_setImage(with:URL(string: url), completed: nil)
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
    static func getAttributedStringWithSpacing(text: String) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: text, attributes:
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
//                NSAttributedString..
            ]
        )
        
        return attributedString
        
    }
}


extension String{
    static func myAttributedString(text: String, spacing forVerticalSpacing: CGFloat) -> NSAttributedString{
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
