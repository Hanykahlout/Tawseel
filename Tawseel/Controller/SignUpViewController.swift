//
//  SignUpViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTextField: TextFeildDesignable!
    @IBOutlet weak var emailAdressTextField: TextFeildDesignable!
    @IBOutlet weak var passwordTextField: TextFeildDesignable!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    func initlization() {
        scrolView.topAnchor.constraint(equalTo: view.topAnchor, constant: -50).isActive = true
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
        setUpScrolView()
    }
    func setUpScrolView() {
        scrolView.delegate = self
        scrolView.isDirectionalLockEnabled = true
    }
    @IBAction func signUpAction(_ sender: Any) {
    }
    
    @IBAction func loginAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func privacyTermsAction(_ sender: Any) {
    }
    
}
extension SignUpViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
}
