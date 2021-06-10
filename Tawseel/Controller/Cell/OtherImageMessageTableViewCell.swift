//
//  OtherImageMessageTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 10/06/2021.
//

import UIKit

class OtherImageMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func setData(message: ChatMessage, image:String){
        userImageView.sd_setImage(with: URL(string: "http://tawseel.pal-dev.com\(image)"), placeholderImage: #imageLiteral(resourceName: "personalImage"))
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatterGet.date(from: message.created_at ?? ""){
            let newDateFormatter = DateFormatter()
            newDateFormatter.locale = Locale(identifier: L102Language.currentAppleLanguage())
            newDateFormatter.dateFormat = "dd MMMM hh:mm a"
            timeLabel.text = newDateFormatter.string(from: date)
        }
        messageImageView.sd_setImage(with: URL(string: "http://tawseel.pal-dev.com\(message.message!)"), placeholderImage: UIImage(systemName: "photo")!)
    }
}

