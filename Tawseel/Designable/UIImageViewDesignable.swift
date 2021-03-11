//
//  File.swift
//  Notes
//
//  Created by Hany Kh on 20/08/2020.
//  Copyright © 2020 Hany Kh. All rights reserved.
//

import Foundation
import UIKit

class UIImageViewDesignable:UIImageView{
    
    @IBInspectable var borderColor:UIColor = UIColor.clear
    @IBInspectable var borderWidth:CGFloat = 0
    
    @IBInspectable var cornerRadius:CGFloat = 0
    
    @IBInspectable var shadowColor:UIColor  = UIColor.clear
    @IBInspectable var shadowRadius:CGFloat = 0
    @IBInspectable var shadowOffset:CGSize = CGSize(width: 0, height: 0)
    @IBInspectable var shadowOpacity:Float = 0
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        layer.cornerRadius = cornerRadius
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        
    }
    
    
    
    
    
    
}
