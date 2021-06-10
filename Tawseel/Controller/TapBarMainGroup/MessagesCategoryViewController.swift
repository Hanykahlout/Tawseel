//
//  MessagesViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import SideMenu
class MessagesCategoryViewController: UIViewController {
    
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var deletingActionPopUpView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var indexPath:IndexPath!
    private var menu :SideMenuNavigationController?
    private var categories:[ChatContactData] = [ChatContactData]()
    private let refreshControl = UIRefreshControl()
    private var counter:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        getCategories(isFromBottom: false)
    }
    
    
    private func initlization(){
        setUpSideMenu()
        setUpTableView()
        setUpViews()
        setUpRefreshControl()
    }
    
    
    private func setUpViews(){
        deleteButton.layer.masksToBounds = false
        cancelButton.layer.masksToBounds = false
        deletingActionPopUpView.layer.masksToBounds = false
        setUpShadowView()
    }
    
    
    private func setUpRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        categoriesTableView.refreshControl = refreshControl
    }
    
    
    @objc private func refresh(){
        getCategories(isFromBottom: false)
    }
    
    
    private func setUpShadowView(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        shadowView.isHidden = true
        if !deletingActionPopUpView.isHidden{
            deletingActionPopUpView.isHidden = true
        }else if !newtworkAlertView.isHidden{
            newtworkAlertView.isHidden = true
        }
    }
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
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
    
    
    private func getCategories(isFromBottom:Bool){
        if !isFromBottom && counter != 1{
            counter = 1
        }
        UserAPI.shard.chatContacts(pageNumber: counter) { (status, messages, data) in
            if status{
                DispatchQueue.main.async {
                    if isFromBottom{
                        self.categories.append(contentsOf: data!)
                    }else{
                        self.categories = data!
                    }
                    self.categories.sort(){ $0.created_at! > $1.created_at!}
                    self.categoriesTableView.reloadData()
                    if !data!.isEmpty && !isFromBottom{
                        self.categoriesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                }
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        UserAPI.shard.deleteChat(order_id: categories[indexPath.row].order_id!) { (status, messages) in
            if status{
                self.categories.remove(at: self.indexPath.row)
                self.categoriesTableView.deleteRows(at: [self.indexPath], with: .automatic)
                self.removePopUp()
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
    }
    
    
    @IBAction func exitAction(_ sender: Any) {
        removePopUp()
    }
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
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
            self.indexPath = indexPath
            self.deletingActionPopUpView.isHidden = false
            self.shadowView.isHidden = false
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "ic_delete_sweep_24px")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8784313725, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let message = categories[indexPath.row]
        vc.isMap = false
        vc.driverId = message.driver_id!
        vc.orderId = message.order_id!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom == height {
            counter += 1
            getCategories(isFromBottom: true)
        }
    }
}

