//
//  ShareAppViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
class ShareAppViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
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
        if let name = URL(string: "AppLink"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
            
        }
    }
    
    
}
