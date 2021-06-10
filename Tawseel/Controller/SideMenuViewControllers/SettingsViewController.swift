//
//  SettingsViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
import DropDown
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var onlinePaymentView: UIView!
    @IBOutlet weak var displayLanguageView: UIView!
    @IBOutlet weak var notificationsSoundView: UIView!
    @IBOutlet var arrows: [UIImageView]!
    @IBOutlet weak var backButton: UIButton!
    private var menu :SideMenuNavigationController?
    private let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeArrowsSide()
        changeSideMenuSide()
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
    }
    
    
    private func initlization(){
        setUpDropDownList()
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
        // onlinePaymentAction
    }
    
    
    @objc private func displayLanguageAction(){
        dropDown.show()
    }
    
    
    private func setUpDropDownList(){
        dropDown.anchorView = displayLanguageView
        dropDown.dataSource = ["العربية","English"]
        dropDown.selectionAction = { (index: Int, item: String) in
            switch index {
            case 0:
                self.changeLanguage(lang: "ar")
            case 1:
                self.changeLanguage(lang: "en")
            default:
                break
            }
        }
    }
    
    
    private func changeLanguage(lang:String){
        if L102Language.currentAppleLanguage() != lang{
            L102Language.changeLanguage(view: self, newLang: lang, rootViewController: "TabBarNav")
        }else{
            GeneralActions.shard.showAlert(target: self, title: NSLocalizedString("Error", comment: ""), message: lang == "ar" ? NSLocalizedString("You are already on Arabic", comment: "") : NSLocalizedString("You are already on English", comment: ""))
        }
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
    
    
    private func changeArrowsSide(){
        if L102Language.currentAppleLanguage() == "ar"{
            for arrow in arrows {
                arrow.image = #imageLiteral(resourceName: "ic_chevron_left_24px")
            }
        }else{
            for arrow in arrows {
                arrow.image = #imageLiteral(resourceName: "ic_chevron_right_24px")
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    
}
