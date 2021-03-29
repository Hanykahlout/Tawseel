//
//  ShareAppViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
class ShareAppViewController: UIViewController {

    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func whatsAppAction(_ sender: Any) {
    }
    
    @IBAction func snapchatAction(_ sender: Any) {
    }
    
    @IBAction func twitterAction(_ sender: Any) {
    }
    
    @IBAction func instagramAction(_ sender: Any) {
    }
    
    @IBAction func copyLinkAction(_ sender: Any) {
    }
    
    
    private func initlization(){
        setUpSideMenu()
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
}
