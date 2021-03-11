//
//  ViewExtension.swift
//  GymReservations
//
//  Created by macbook on 08/03/2021.
//

import UIKit

extension UIView {
    func setGradient(firstColor:UIColor,secondColor:UIColor,startPoint:CGPoint?,endPoint:CGPoint?) {
        let colours = [firstColor,secondColor]
        
        let gradient: CAGradientLayer = CAGradientLayer()
        //        gradient.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        if let startPoint = startPoint , let endPoint = endPoint{
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
