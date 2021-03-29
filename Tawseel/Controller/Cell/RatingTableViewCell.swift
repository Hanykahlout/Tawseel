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
    
    func setData(ratingInfo info:RatingInfo) {
        delegateImage.image = info.delegateImage
        delegateName.text = info.delegateName
        commentLabel.text = info.userComment
        ratingView.rating = info.ratingNumber
    }

}

