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
    
    func setData(messageCatgoryInfo info:MessagesCategoryInfo) {
        userImage.image = info.userImage
        userNameLabel.text = info.userName
        lastMessageLabel.text = info.lastMessage
        timeLabel.text = info.time
        if let num = info.numberOfUnReadMessages{
            numberOfMessagesLabel.text = "\(num)"
            numberOfMessagesLabel.isHidden = false
        }
    }
    
}

