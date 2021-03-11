//
//  WelcomePageCollectionViewCell.swift
//  Tawseel
//
//  Created by macbook on 11/03/2021.
//

import UIKit

class WelcomePageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    func setData(data:(image:UIImage,imageHeightConstant:CGFloat,title:String,details:String)) {
        imageHeight.constant = data.imageHeightConstant
        imageView.image = data.image
        titleLabel.text = data.title
        detailsLabel.text = data.details
    }
}
