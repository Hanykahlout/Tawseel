//
//  MessagesCategoryTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 22/03/2021.
//

import UIKit

class MessagesCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberOfMessagesLabel: UILabel!
    
    func setData(messageCatgoryInfo info:ChatContactData) {
        userImage.sd_setImage(with: URL(string: "http://tawseel.pal-dev.com\(info.avatar ?? "")"), placeholderImage: #imageLiteral(resourceName: "personalImage"))
        userNameLabel.text = info.iDName
        switch info.type! {
        case "text":
            lastMessageLabel.text = info.message
        case "audio":
            lastMessageLabel.text = NSLocalizedString("Voice Message", comment: "")
        case "image":
            lastMessageLabel.text = NSLocalizedString("Photo", comment: "")
        case "video":
            lastMessageLabel.text = NSLocalizedString("Video", comment: "")
        case "map":
            lastMessageLabel.text = NSLocalizedString("Location", comment: "")
        case "contact":
            lastMessageLabel.text = NSLocalizedString("Contact", comment: "")
        default:
            break
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        
        if let date =  dateFormatter.date(from: info.created_at ?? ""){
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dd/MM/yyyy"
            timeLabel.text = newDateFormatter.string(from: date)
        }
        
        if Int(info.unreaded ?? "0")! > 0{
            numberOfMessagesLabel.text = info.unreaded
            numberOfMessagesLabel.isHidden = false
        }
    }
    
}

