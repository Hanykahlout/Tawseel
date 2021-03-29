//
//  MessagesViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import SideMenu
class MessagesCategoryViewController: UIViewController {
    
    @IBOutlet weak var shadowBlackView: UIView!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var deletingActionPopUpView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    private var categories:[MessagesCategoryInfo] = [MessagesCategoryInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
    }
    
    @IBAction func exitAction(_ sender: Any) {
    }
    
    private func initlization(){
        setUpSideMenu()
        setUpTableView()
        setUpViews()
        getCategories()
    }
    
    private func setUpViews(){
        deleteButton.layer.masksToBounds = false
        cancelButton.layer.masksToBounds = false
        deletingActionPopUpView.layer.masksToBounds = false
        setUpShadowView()
    }
    
    private func setUpShadowView(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    @objc private func removePopUp(){
        shadowView.isHidden = true
        deletingActionPopUpView.isHidden = true
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
    }
    
    private func getCategories(){
        categories.append(MessagesCategoryInfo(userImage: #imageLiteral(resourceName: "me"), userName: "Hany", lastMessage: "Hello World", time: "12:00 AM", numberOfUnReadMessages: 7))
        
        categories.append(MessagesCategoryInfo(userImage: #imageLiteral(resourceName: "me"), userName: "Hany", lastMessage: "Hello World", time: "12:00 AM"))
        
        categories.append(MessagesCategoryInfo(userImage: #imageLiteral(resourceName: "me"), userName: "Hany", lastMessage: "Hello World", time: "12:00 AM"))
        
        categories.append(MessagesCategoryInfo(userImage: #imageLiteral(resourceName: "me"), userName: "Hany", lastMessage: "Hello World", time: "12:00 AM", numberOfUnReadMessages: 2))
        
        categories.append(MessagesCategoryInfo(userImage: #imageLiteral(resourceName: "me"), userName: "Hany", lastMessage: "Hello World", time: "12:00 AM"))
    }
    
}

extension MessagesCategoryViewController: UITableViewDelegate , UITableViewDataSource{
    private func setUpTableView(){
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCategoryTableViewCell", for: indexPath) as! MessagesCategoryTableViewCell
        cell.setData(messageCatgoryInfo: categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "ic_delete_sweep_24px")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8784313725, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}
