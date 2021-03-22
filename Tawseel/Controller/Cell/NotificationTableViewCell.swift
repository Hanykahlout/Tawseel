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
    
    func setData(notificationInfo info : NotificationInfo){
        notificationTextLabel.text = info.text
        timeLabel.text = info.time
        if info.isNew {
            notificationView.backgroundColor = #colorLiteral(red: 1, green: 0.9137254902, blue: 0.768627451, alpha: 1)
        }
    }

}
