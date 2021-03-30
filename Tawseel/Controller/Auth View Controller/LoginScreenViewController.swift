//
//  LoginScreenViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit
import FBSDKLoginKit
import Firebase
class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        initlization()
    }
    
    @IBAction func signInWithFacebook(_ sender: Any) {
        loginWithFacebook()
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        
    }
    
    @IBAction func signUpAtion(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        performLogin()
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RsetPasswordViewController") as! RsetPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func privacyTermsAction(_ sender: Any) {
    }
    
    private func initlization() {
        
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
    }

    private func performLogin(){
        UserAPI.shared.login(userName: userNameTextField.text!, password: passwordTextField.text!) { (status, token, user, messages) in
            if status{
                if let user = user {
                    UserDefaultsData.shared.setToken(token: token)
                    UserDefaultsData.shared.saveUser(user: user)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarNav") as! UINavigationController
                    self.navigationController?.present(vc, animated: true, completion: nil)
                }
            }else{
                if let messages = messages{
                    let alertC = UIAlertController(title: "Error", message: messages[0], preferredStyle: .alert)
                    alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alertC, animated: true, completion: nil)
                }
            }
        }
    }
}
// MARK: - Perform Login With Facebook
extension LoginScreenViewController{
    
    private func loginWithFacebook() {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
        } else {
            
            loginManager.logIn(permissions: ["public_profile", "email","phone"], from: self) { (result, error) in
                guard error == nil else {
                    self.showAlert(title: "Error", message: "There is an error in your login with facebook process")
                    return
                }
                
                guard let result = result, !result.isCancelled else {
                    // User cancelled login
                    return
                }
                if let token = AccessToken.current{
                    let cardinate = FacebookAuthProvider.credential(withAccessToken: token.tokenString )
//                    Authentication.shard.signInWithCardinate(cardinate: cardinate) { (status) in
//                        if status{
//                            self.getFacebookUserData { (status, user) in
//                                if status{
//                                    FStorage.shard.uploadImage(uid: user!.uid, imageData: try! Data(contentsOf: URL(string: user!.imageUrl)!) ) { (status, url) in
//                                        let updateUser = UserInfo(uid: user!.uid, name: user!.name , email: user!.email, imageUrl: url)
//                                        FFirestore.shard.saveUser(user: updateUser) { (status , docID) in
//                                            if status{
//                                                updateUser.docID = docID
//                                                UserDefaultsData.shard.setUser(user: updateUser)
//                                                UserDefaults.standard.setValue(true, forKey: "ISUSER")
//                                                let vc = self.storyboard?.instantiateViewController(withIdentifier:"UserNav") as! UINavigationController
//                                                self.navigationController?.present(vc, animated: true, completion: nil)
//                                            }else{
//                                                SCLAlertView().showError("Error", subTitle: "There is an error in saving your data")
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }else{
//                            SCLAlertView().showError("Error", subTitle: "Field to login with facebook")
//                        }
//                    }
                }
            }
        }
    }
    
    private func getFacebookUserData(callBack:@escaping (_ status:Bool,_ userData:User?)-> Void) {
        GraphRequest(graphPath: "me", parameters: ["fields":"email,id,name,picture"]).start { (_, results, error) in
            if let _ = error{
                callBack(false,nil)
                return
            }
            
            let res = results as! [String:Any] as NSDictionary
            let id = res.value(forKey: "id") as! String
            let fullName = res.value(forKey: "name") as! String
            let email = res.value(forKey: "email") as! String
            let phone = res.value(forKey: "phone") as! String
            let imageURL = ((res.value(forKey: "picture") as! [String:Any])["data"] as! [String:Any])["url"] as! String
//            callBack(true,User(id: id, username: fullName, email: email, gpsLng: "", gpsLat: "", gpsAddress: "", name: "", phone: phone, avatar: "", created_at: <#T##String#>, updated_at: <#T##String#>))
        }
    }
    
    private func showAlert(title:String,message:String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertC, animated: true, completion: nil)
    }
}


