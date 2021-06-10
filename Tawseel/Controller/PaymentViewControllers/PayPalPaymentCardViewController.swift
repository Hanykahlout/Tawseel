//
//  PayPalPaymentCardViewController.swift
//  Tawseel
//
//  Created by macbook on 23/03/2021.
//

import UIKit
import SideMenu
class PayPalPaymentCardViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    

    @IBOutlet weak var binButton: UIButton!
    @IBOutlet weak var cardRadioButton: UIButton!
    @IBOutlet weak var payPalView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var isSaveSwitch: UISwitch!
    @IBOutlet weak var backButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCardDate()
        if L102Language.currentAppleLanguage() == "ar"{
            SideMenuManager.default.rightMenuNavigationController = nil
            SideMenuManager.default.leftMenuNavigationController = menu
        }else{
            SideMenuManager.default.leftMenuNavigationController = nil
            SideMenuManager.default.rightMenuNavigationController = menu
        }
    }
    
    
    private func initlization(){
        setUpSideMenu()
        setUpTextField()
        setUpBlackView()
    }
    
    
    
    private func setUpBlackView(){
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        blackView.isHidden = true
        newtworkAlertView.isHidden = true
    }
    
    
    private func setCardDate(){
        if UserDefaults.standard.bool(forKey: "Is_Exist_PayPal_Card"){
            binButton.isHidden = false
            cardRadioButton.isHidden = false
            let cardData = UserDefaultsData.shard.getSavedPayPalCardData()
            emailTextField.text = cardData.email
            passwordTextField.text = cardData.password
        }
    }
    
    
    private func addLeftPadding(textField:UITextField){
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12, height: textField.bounds.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    
    private func setUpTextField(){
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        addLeftPadding(textField: emailTextField)
        addLeftPadding(textField: passwordTextField)
    }
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
        
    
    @IBAction func binAction(_ sender: Any) {
        binButton.isHidden = true
        cardRadioButton.isHidden = true
        UserDefaultsData.shard.removePayPalCardData()
    }
    
    
    @IBAction func cardRadioButtonAction(_ sender: Any) {
        cardRadioButton.isSelected = !cardRadioButton.isSelected
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func paymentAction(_ sender: Any) {
    }
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
}

