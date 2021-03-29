//
//  LoginScreenViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        initlization()
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
        performLogin()
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RsetPasswordViewController") as! RsetPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func privacyTermsAction(_ sender: Any) {
    }
    
    private func initlization() {
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
    }

    private func performLogin(){
        UserAPI.shared.login(userName: userNameTextField.text!, password: passwordTextField.text!) { (status, token, user, messages) in
            if status{
                if let user = user {
                    UserDefaultsData.shared.setToken(token: token)
                    UserDefaultsData.shared.saveUser(user: user)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarNav") as! UINavigationController
                    self.navigationController?.present(vc, animated: true, completion: nil)
                }
            }else{
                if let messages = messages{
                    let alertC = UIAlertController(title: "Error", message: messages[0], preferredStyle: .alert)
                    alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alertC, animated: true, completion: nil)
                }
            }
        }
    }
}

