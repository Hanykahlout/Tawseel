//
//  RatingTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import Cosmos
class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var delegateImage: UIImageView!
    @IBOutlet weak var delegateName: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    
    func setData(ratingInfo info:Rate) {
        delegateImage.sd_setImage(with: URL(string: "http://tawseel.pal-dev.com\(info.driver!.avatar ?? "")"), placeholderImage: #imageLiteral(resourceName: "personalImage"))
        delegateName.text = info.driver!.iDName ?? ""
        commentLabel.text = info.text ?? ""
        ratingView.rating = Double(info.stars ?? 0)
    }

}

