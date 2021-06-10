//
//  BillsTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 24/03/2021.
//

import UIKit

class BillsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deliveryAmountLabel: UILabel!
    @IBOutlet weak var billNumberLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var toLocationLabel: UILabel!
    
    func setData(billInfo info :Order)  {
        deliveryAmountLabel.text = "\(info.price ?? -1)\(NSLocalizedString("SR", comment: ""))"
        billNumberLabel.text = info.id != nil ? String(info.id!) : ""
        fromLocationLabel.text = info.from_address ?? ""
        toLocationLabel.text = info.to_address ?? ""
    }
    
    
}

