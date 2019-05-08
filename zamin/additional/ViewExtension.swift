//
//  ViewExtension.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 5/8/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import UIKit



extension UITableView {
    
    func setBigEmptyView() {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        print("Frame: \(self.frame.width)   \(self.frame.height)")
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let refreshButton = UIButton(type: .custom)
        
        messageImageView.backgroundColor = .clear
        messageImageView.contentMode = .scaleToFill
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        
        refreshButton.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.setTitle(LanguageHelper.getString(stringId: .text_refresh), for: .normal)
        refreshButton.layer.cornerRadius = 4.0
        refreshButton.clipsToBounds = true
        
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(refreshButton)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -70).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        refreshButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70).isActive = true
        refreshButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 152).isActive = true
        
        titleLabel.text = LanguageHelper.getString(stringId: .message_no_connection)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        messageImageView.image = #imageLiteral(resourceName: "ic_nonetwokr")
        refreshButton.tag = 1010102
        
        //        UIView.animate(withDuration: 1, animations: {
        //
        //            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        //        }, completion: { (finish) in
        //            UIView.animate(withDuration: 1, animations: {
        //                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
        //            }, completion: { (finishh) in
        //                UIView.animate(withDuration: 1, animations: {
        //                    messageImageView.transform = CGAffineTransform.identity
        //                })
        //            })
        //
        //        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func setBigNoItemView(){
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        messageImageView.contentMode = .scaleToFill
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        
        
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(titleLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -70).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        titleLabel.text = LanguageHelper.getString(stringId: .text_no_item)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        messageImageView.image = #imageLiteral(resourceName: "ic_emptypage")
        
        //        UIView.animate(withDuration: 1, animations: {
        //
        //            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        //        }, completion: { (finish) in
        //            UIView.animate(withDuration: 1, animations: {
        //                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
        //            }, completion: { (finishh) in
        //                UIView.animate(withDuration: 1, animations: {
        //                    messageImageView.transform = CGAffineTransform.identity
        //                })
        //            })
        //
        //        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func removeBackView(){
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
}
