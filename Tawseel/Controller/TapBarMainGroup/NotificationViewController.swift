//
//  NotificationViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import SideMenu
class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    private var menu :SideMenuNavigationController?
    private var notificationData = [NotificationInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    private func initlization() {
        setUpSideMenu()
        setUpTableView()
        getNotificationData()
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
    }
    
    private func getNotificationData(){
        notificationData.append(NotificationInfo(date: "March 10, 2021", notification: [Notifications(isNew: true, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: true, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM")]))
        
        notificationData.append(NotificationInfo(date: "March 10, 2021", notification: [Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM"),Notifications(isNew: false, text: "Notice of a delivery request", time: "09:35 AM")]))
    }
    
}

extension NotificationViewController: UITableViewDelegate , UITableViewDataSource{
    
    private func setUpTableView(){
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return notificationData[section].date
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        let label = UILabel(frame: .init(x: 13, y: vw.frame.size.height/2, width: 150, height: 16))
        label.font = UIFont(name: "Tajawal-Bold", size: 16)
        label.text = notificationData[section].date
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
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "ic_delete_sweep_24px")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8784313725, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BillVisaDetailsViewController") as! BillVisaDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
