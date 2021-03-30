//
//  SignUpViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit
class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailAdressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        performSignUp()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func privacyTermsAction(_ sender: Any) {
    }
    
    private func initlization() {
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
    }
    
    private func performSignUp(){
        UserAPI.shared.register(userName: userNameTextField.text!, password: passwordTextField.text!, email: emailAdressTextField.text!) { (status, token, user, messages) in
            if status {
                if let user = user {
                    UserDefaultsData.shared.saveUser(user: user)
                    UserDefaultsData.shared.setToken(token: token)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileNav") as! UINavigationController
                    UserDefaults.standard.setValue(true, forKey: "NotEndFromUserProfile")
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
