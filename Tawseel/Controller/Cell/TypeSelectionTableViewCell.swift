//
//  TypeSelectionTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 26/05/2021.
//

import UIKit

class TypeSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    var indexPath:IndexPath?
    var delegate:SelectionType?
    
    func setData(typeData:(index:Int,text:String,isSelected:Bool)){
        typeLabel.text = typeData.text
        selectButton.isSelected = typeData.isSelected
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        if let indexPath = indexPath , let delegate = delegate{
            delegate.select(indexPath: indexPath)
        }
    }
    
}

protocol SelectionType {
    func select(indexPath:IndexPath)
}
