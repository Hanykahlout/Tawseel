//
//  LoginScreenViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit

class LoginScreenViewController: UIViewController {
    @IBOutlet weak var userNameTextField: TextFeildDesignable!
    @IBOutlet weak var passwordTextField: TextFeildDesignable!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        initlization()
    }
    
    func initlization() {
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
    }

    @IBAction func signInWithFacebook(_ sender: Any) {
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
    }
    @IBAction func signUpAtion(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func loginAction(_ sender: Any) {
    }
    @IBAction func forgetPasswordAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RsetPasswordViewController") as! RsetPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func privacyTermsAction(_ sender: Any) {
    }
}
