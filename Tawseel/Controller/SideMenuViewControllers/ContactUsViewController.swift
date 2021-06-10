//
//  ContactUsViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
class ContactUsViewController: UIViewController {
    
    
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
    }
    
    
    private func initlization(){
        setUpBlackView()
        addLeftPadding(textField: emailTextField)
        setUpSideMenu()
        setUpTextView()
        emailTextField.borderStyle = .none
        sendButton.layer.masksToBounds = false
        
    }
    
    
    private func setUpBlackView(){
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        blackView.isHidden = true
        newtworkAlertView.isHidden = true
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
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    private func changeSideMenuSide(){
        if L102Language.currentAppleLanguage() == "ar"{
            menu?.leftSide = true
            SideMenuManager.default.rightMenuNavigationController = nil
            SideMenuManager.default.leftMenuNavigationController = menu
        }else{
            menu?.leftSide = false
            SideMenuManager.default.leftMenuNavigationController = nil
            SideMenuManager.default.rightMenuNavigationController = menu
        }
    }
    
    
    private func setUpTextView(){
        messageTextView.delegate = self
        messageTextView.text = NSLocalizedString("The Message", comment: "")
        messageTextView.textColor = #colorLiteral(red: 0.7137254902, green: 0.7490196078, blue: 0.7411764706, alpha: 1)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func whatsAppAction(_ sender: Any) {
        GeneralAPI.shard.whatsappNumber { (status, messages, phoneNumber) in
            if status{
                let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.openURL(appURL)
                } else {
                    self.titleLabel.text = NSLocalizedString("WhatsApp Not Available App", comment: "")
                    self.blackView.isHidden = false
                    self.newtworkAlertView.isHidden = false
                }
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
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
    
    
    @IBAction func sendAction(_ sender: Any) {
        GeneralAPI.shard.contactUsApi(email: emailTextField.text!, messageText: messageTextView.text, name: UserDefaultsData.shard.getUser().username ?? "") { (status, messages) in
            if status{
                GeneralActions.shard.showAlert(target: self, title: NSLocalizedString("Successful Send", comment: ""), message: NSLocalizedString("The message has been sent successfully", comment: ""))
                DispatchQueue.main.async {
                    self.messageTextView.text = ""
                }
            }else{
                
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
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
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
}

extension ContactUsViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == NSLocalizedString("The Message", comment: "") &&  textView.textColor == #colorLiteral(red: 0.7137254902, green: 0.7490196078, blue: 0.7411764706, alpha: 1){
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = NSLocalizedString("The Message", comment: "")
            textView.textColor = #colorLiteral(red: 0.7137254902, green: 0.7490196078, blue: 0.7411764706, alpha: 1)
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    
}




