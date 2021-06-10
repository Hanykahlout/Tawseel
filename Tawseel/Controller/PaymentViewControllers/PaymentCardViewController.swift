//
//  PaymentCardViewController.swift
//  Tawseel
//
//  Created by macbook on 23/03/2021.
//

import UIKit
import SideMenu
class PaymentCardViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var savedCardNumber: UILabel!
    @IBOutlet weak var cardView: GraidentView!
    @IBOutlet weak var visaRadioButton: UIButton!
    @IBOutlet weak var binButton: UIButton!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var isSaveSwitch: UISwitch!
    @IBOutlet weak var paymentButton: UIButton!
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
        cardView.layer.masksToBounds = true
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
    
    
    private func setUpTextField(){
        cardNumberTextField.borderStyle = .none
        userNameTextField.borderStyle = .none
        cvvTextField.borderStyle = .none
        endDateTextField.borderStyle = .none
        addLeftPadding(textField: cardNumberTextField)
        addLeftPadding(textField: userNameTextField)
        addLeftPadding(textField: cvvTextField)
        addLeftPadding(textField: endDateTextField)
    
    }
    
    
    private func addLeftPadding(textField:UITextField){
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12, height: textField.bounds.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
    }
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    private func setCardDate(){
        if UserDefaults.standard.bool(forKey: "Is_Exist_Card"){
            binButton.isHidden = false
            visaRadioButton.isHidden = false
            let cardData = UserDefaultsData.shard.getSavedCardData()
            savedCardNumber.text = cardData.number
            cardNumberTextField.text = cardData.number
            userNameTextField.text = cardData.userName
            cvvTextField.text = cardData.cvv
            endDateTextField.text = cardData.endDate
        }
    }
    
    
    @IBAction func binAction(_ sender: Any) {
        visaRadioButton.isHidden = true
        binButton.isHidden = true
        UserDefaultsData.shard.removeCardData()
    }
    
    
    @IBAction func visaRadionButtonAction(_ sender: Any) {
        visaRadioButton.isSelected = !visaRadioButton.isSelected
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func paymentAction(_ sender: Any) {
        
    }
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
}


