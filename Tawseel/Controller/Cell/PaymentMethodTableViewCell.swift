//
//  PaymentMethodTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 24/05/2021.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paymentMethodImage: UIImageView!
    @IBOutlet weak var isSelectedRadiuoButton: UIButton!
    
    public var delegate:PaymentMethod?
    public var indexPath:IndexPath?
    func setData(paymentMethodInfo info:PaymentMethodsInfo){
        titleLabel.text = info.title
        paymentMethodImage.image = info.image
        isSelectedRadiuoButton.isSelected = info.isSelected
    }
    
    @IBAction func isSelectedAction(_ sender: Any) {
        if let delegate = delegate,let indexPath = indexPath{
            delegate.select(indexPath:indexPath)
        }
    }
}

protocol PaymentMethod {
    func select(indexPath:IndexPath)
}
