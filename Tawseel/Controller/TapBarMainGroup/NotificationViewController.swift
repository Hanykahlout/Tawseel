//
//  NotificationViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import SideMenu
import Cosmos
class NotificationViewController: UIViewController {
    
    
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var completeDeliveryPopupView: UIView!
    @IBOutlet weak var ratingPopupView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var userRatingCommintTextField: UITextField!
    @IBOutlet weak var deliveredButton: UIButton!
    @IBOutlet weak var notDeliveredButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    private var notificationData = [NotificationInfo]()
    private let refreshControl = UIRefreshControl()
    private var counter:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        getNotificationData(isFromBottom: false)
    }
    
    
    private func initlization() {
        setUpSideMenu()
        setUpTableView()
        setUpRefreshControl()
        completeDeliveryPopupView.layer.masksToBounds = false
        setUpViews()
        userRatingCommintTextField.layer.masksToBounds = false
        deliveredButton.layer.masksToBounds = false
        notDeliveredButton.layer.masksToBounds = false
        userRatingCommintTextField.borderStyle = .none
    }
    
    
    private func setUpViews(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePopUp)))
        shadowView.isUserInteractionEnabled = true
    }
    
    
    @objc private func hidePopUp(){
        if !ratingPopupView.isHidden{
            ratingPopupView.isHidden = true
        }else if !completeDeliveryPopupView.isHidden{
            completeDeliveryPopupView.isHidden = true
        }else if !newtworkAlertView.isHidden{
            newtworkAlertView.isHidden = true
        }
        shadowView.isHidden = true
    }
    
    
    private func setUpRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        notificationTableView.refreshControl = refreshControl
    }
    
    @objc private func refresh(){
        getNotificationData(isFromBottom: false)
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
    
    
    private func getNotificationData(isFromBottom:Bool){
        if !isFromBottom && counter != 1{
            counter = 1
            notificationData.removeAll()
            notificationTableView.reloadData()
        }
        UserAPI.shard.getNotification(pageNumber: counter) { (status, messages, data) in
            if status{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let newDateFormatter = DateFormatter()
                newDateFormatter.dateFormat = "MMMM dd, yyyy"
                for notification in data! {
                    let response = self.getTextAccordingToType(notificationData: notification)
                    let date = dateFormatter.date(from: notification.created_at!) ?? Date()
                    if !self.notificationData.isEmpty{
                        var isExist = false
                        for index in 0..<self.notificationData.count{
                            if newDateFormatter.string(from: self.notificationData[index].date) == newDateFormatter.string(from: date){
                                self.notificationData[index].notification.append(Notifications(id:notification.id!,isNew: false , text: response.text, time: date , aciton: response.action))
                                isExist = true
                                break
                            }
                        }
                        if !isExist{
                            self.notificationData.append(NotificationInfo(date: date, notification: [Notifications(id:notification.id!,isNew: false, text: response.text, time: date, aciton: response.action)]))
                        }
                    }else{
                        self.notificationData.append(NotificationInfo(date: date, notification: [Notifications(id:notification.id!,isNew: false, text: response.text, time: date, aciton: response.action)]))
                    }
                }
                self.notificationData.sort(){$0.date > $1.date}
                self.notificationTableView.reloadData()
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
    
    
    private func getTextAccordingToType(notificationData:NotificationData) -> (text:String,action:()->Void){
        
        switch notificationData.type! {
        case "new-bill":
            return ("\(NSLocalizedString("New Bill\nNumber: ", comment: ""))\(notificationData.target!)",{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BillVisaDetailsViewController") as! BillVisaDetailsViewController
                vc.billId = Int(notificationData.target!)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case "deliver-order":
            return ("\(NSLocalizedString("Notice of delivery request\nFor order number: ", comment: ""))\(notificationData.target!)",{
                self.completeDeliveryPopupView.isHidden = false
                self.shadowView.isHidden = false
            })
        case "deliver-confirm":
            return ("\(NSLocalizedString("The request has been delivered\nNumber: ", comment: ""))\(notificationData.target!)",{
                self.tabBarController?.selectedIndex = 0
            })
        case "accept-order":
            return ("\(NSLocalizedString("The messaging request for ", comment: ""))\(notificationData.target!)\(NSLocalizedString(" request has been confirmed by the delivery representative", comment: ""))",{
                self.tabBarController?.selectedIndex = 0
            })
        case "refuse-order":
            return ("\(NSLocalizedString("The messaging request for the ", comment: ""))\(notificationData.target!)\(NSLocalizedString(" request was rejected by the delivery person", comment: ""))",{
                self.tabBarController?.selectedIndex = 0
            })
        case "user-add-rate":
            return ("\(NSLocalizedString("The driver ", comment: ""))\(notificationData.target!)\(NSLocalizedString(" has been rated.", comment: ""))",{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case "approve-bill":
            return ("\(NSLocalizedString("Bill No. ", comment: ""))\(notificationData.target!)\(NSLocalizedString(" was paid", comment: ""))",{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BillsDetalisViewController") as! BillsDetalisViewController
                vc.billId = Int(notificationData.target!)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case "cancel-bill":
            return ("\(NSLocalizedString("Bill No. ", comment: ""))\(notificationData.target!)\(NSLocalizedString(" has been canceled.", comment: ""))",{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BillsDetalisViewController") as! BillsDetalisViewController
                vc.billId = Int(notificationData.target!)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case "admin-accept-order" , "admin-refues-order" , "admin-id-papers" , "admin-activate-account" , "admin-deactivate-account" , "admin-financial-boost" , "admin-new-rate", "other":
            return (notificationData.target!,{})
        case "admin-cash":
            return (notificationData.target!,{
                // Go to Managment Bills View Controller
            })
        default:
            return (notificationData.target!,{})
        }
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func deliveredAction(_ sender: Any) {
        
    }
    
    
    @IBAction func notDeliverdAction(_ sender: Any) {
        
    }
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        hidePopUp()
    }
}

extension NotificationViewController: UITableViewDelegate , UITableViewDataSource{
    private func setUpTableView(){
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        let label = UILabel(frame: .init(x: 13, y: vw.frame.size.height/2, width: 150, height: 16))
        label.font = UIFont(name: "Tajawal-Bold", size: 16)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        if dateFormatter.string(from: notificationData[section].date) != dateFormatter.string(from: Date()) {
            label.text = dateFormatter.string(from: notificationData[section].date)
        }else{
            label.text = "Today"
        }
        vw.addSubview(label)
        return vw
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! NotificationTableViewCell
        cell.notificationView.backgroundColor = notificationData[indexPath.section].notification[indexPath.row].isNew ? #colorLiteral(red: 1, green: 0.9137254902, blue: 0.768627451, alpha: 1) : .white
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData[section].notification.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.setData(notificationInfo: notificationData[indexPath.section].notification[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            UserAPI.shard.deleteNotification(notificationId: String(self.notificationData[indexPath.section].notification[indexPath.row].id)) { (status, messages) in
                if !status{
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
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "ic_delete_sweep_24px")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8784313725, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationData[indexPath.section].notification[indexPath.row].aciton()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom == height {
            counter += 1
            getNotificationData(isFromBottom: true)
        }
        
    }
    
}

