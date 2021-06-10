//
//  RsetPasswordViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit

class RsetPasswordViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }

    
    private func initlization() {
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
        setUpBlackView()
    }
    
    
    private func setUpBlackView(){
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        blackView.isHidden = true
        newtworkAlertView.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            loginButton.setImage(#imageLiteral(resourceName: "aa"), for: .normal)
        }
    }
    
    
    private func performRestpassword(){
        UserAPI.shard.restPassword(username: userNameTextField.text!, email: emailAddressTextField.text!) { (status, messages) in
            if status{
                self.titleLabel.text = NSLocalizedString("A new password has been sent to your email", comment: "")
                self.blackView.isHidden = false
                self.newtworkAlertView.isHidden = false
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        if !messages.isEmpty{
                            self.titleLabel.text = messages[0]
                            self.blackView.isHidden = false
                            self.newtworkAlertView.isHidden = false
                        }
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
    }
    
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        performRestpassword()
    }
    
    
    @IBAction func privacyTermsAction(_ sender: Any) {
    }
    
    
    @IBAction func signInAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
    
}


