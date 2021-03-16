//
//  RsetPasswordViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit

class RsetPasswordViewController: UIViewController {
    @IBOutlet weak var userNameTextField: TextFeildDesignable!
    
    @IBOutlet weak var emailAddressTextField: TextFeildDesignable!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    func initlization() {
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
    }
    @IBAction func resetPasswordAction(_ sender: Any) {
    }
    @IBAction func privacyTermsAction(_ sender: Any) {
    }
}


