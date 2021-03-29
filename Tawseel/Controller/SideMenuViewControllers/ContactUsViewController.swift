//
//  ContactUsViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func whatsAppAction(_ sender: Any) {
    
    }
    
    @IBAction func sendAction(_ sender: Any) {
    
    }
    
    
    private func initlization(){
        setUpSideMenu()
        emailTextField.borderStyle = .none
        sendButton.layer.masksToBounds = false
        setUpTextView()
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    private func setUpTextView(){
        messageTextView.text = "The Message"
        messageTextView.textColor = #colorLiteral(red: 0.7137254902, green: 0.7490196078, blue: 0.7411764706, alpha: 1)
        messageTextView.delegate = self
    }
    
}

extension ContactUsViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "The Message" &&  textView.textColor == #colorLiteral(red: 0.7137254902, green: 0.7490196078, blue: 0.7411764706, alpha: 1){
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "The Message"
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




