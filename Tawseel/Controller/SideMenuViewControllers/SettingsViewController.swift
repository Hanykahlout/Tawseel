//
//  SettingsViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var onlinePaymentView: UIView!
    @IBOutlet weak var displayLanguageView: UIView!
    @IBOutlet weak var notificationsSoundView: UIView!
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
    
    
    private func initlization(){
        setUpViews()
        setUpSideMenu()
    }
    
    private func setUpViews(){
        onlinePaymentView.layer.masksToBounds = false
        displayLanguageView.layer.masksToBounds = false
        notificationsSoundView.layer.masksToBounds = false
        
        onlinePaymentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onlinePaymentAction)))
        displayLanguageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayLanguageAction)))
    }
    
    @objc private func onlinePaymentAction(){
        print("onlinePaymentAction")
    }
    
    @objc private func displayLanguageAction(){
        print("displayLanguageAction")
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
}
