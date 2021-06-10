//
//  AppDelegate.swift
//  Tawseel
//
//  Created by macbook on 09/03/2021.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import CoreLocation
import Firebase
import GoogleSignIn
@main
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate{
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyDqE8cCBLfMH5ka5LLW02YvBOpKhEsORrA")
        GMSPlacesClient.provideAPIKey("AIzaSyDqE8cCBLfMH5ka5LLW02YvBOpKhEsORrA")
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = "624348188826-2c4u4c87jqn1osnodm0adkme36il540s.apps.googleusercontent.com"
        
        L102Localizer.DoTheMagic()
        
        
        self.registerForPushNotifications()
        
        
        return true
    }
    
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    private func goToTabBarNav(token:String,user:User?){
        
            UserDefaultsData.shard.setToken(token: token)
            UserDefaultsData.shard.saveUser(user: user!)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            UserAPI.shard.getProfileData { (status, messages, user) in
                if status{
                    var vc:UINavigationController
                    if let _ = user!.gpsLat{
                        vc  = storyboard.instantiateViewController(withIdentifier: "TabBarNav") as! UINavigationController
                    }else{
                        vc  = storyboard.instantiateViewController(withIdentifier: "UserProfileNav") as! UINavigationController
                    }
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
            }
    }
    
    
    // MARK:- Google Sign In Action
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if !UserDefaultsData.shard.isloggedIn(){
            if let error = error {
                if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                    
                } else {
                    // error here
                }
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken,
                                                           accessToken: user.authentication.accessToken)
            UserAPI.shard.signInWithCardinateInFirebase(cardinate: credential) { (status) in
                if status{
                    UserAPI.shard.loginWithSoicalMedia(type: .google, email: String(describing: user.profile.email!), id: String(describing: user.userID!) , name: String(describing: user.profile.name!)) { (status, user, messages, token) in
                        if status{
                            self.goToTabBarNav(token:token,user:user)
                        }
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    
    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app,open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return  GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
}

