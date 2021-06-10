//
//  NotificationTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 22/03/2021.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationView.layer.masksToBounds = false
    }
    
    func setData(notificationInfo info : Notifications){
        notificationTextLabel.text = info.text
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "hh:mm a"
        timeLabel.text = newDateFormatter.string(from: info.time)
    }
}


