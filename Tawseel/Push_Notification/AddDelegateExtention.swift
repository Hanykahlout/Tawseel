//
//  PushNotificationManager.swift
//  GymReservations
//
//  Created by macbook on 21/04/2021.
//

import Foundation
import FirebaseMessaging

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate{
    
    func registerForPushNotifications() {
        Messaging.messaging().delegate = self

        let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        if let fcmToken = fcmToken{
            UserDefaultsData.shard.setFCMToken(fcmToken: fcmToken)
//            UserAPI.shard.updateFCMToken(device: "ios" , FCMToken: fcmToken) { (status, messages) in
//                if !status{
//                    print("Errrrror \(messages[0])")
//                }
//            }
        }
    }
    
    // When user click on notification what will happen
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        
        completionHandler()
    }
    
    // just For Receve Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        completionHandler([[.sound,.alert,.badge]])
    }
    
  
}

