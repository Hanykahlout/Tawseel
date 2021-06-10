//
//  GeneralActions.swift
//  Tawseel
//
//  Created by macbook on 30/05/2021.
//

import UIKit
import Network

class GeneralActions {
    private let monitor = NWPathMonitor()
    public static var shard: GeneralActions = {
        let generalActions = GeneralActions()
        return generalActions
    }()
    
    // MARK:- Alert Action
    
    func showAlert(target:UIViewController,title:String,message:String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        target.present(alertC, animated: true, completion: nil)
    }
    
    // MARK:- Check Network Connection
    
    func monitorNetwork(conectedAction:(()->Void)?,notConectedAction:(()->Void)?){
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied{
                notConectedAction?()
            }else{
                conectedAction?()
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }

}
