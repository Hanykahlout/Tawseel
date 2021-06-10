//
//  LoginScreenViewController.swift
//  Tawseel
//
//  Created by macbook on 10/03/2021.
//

import UIKit
import FBSDKLoginKit
import Firebase
import CoreLocation
import GoogleSignIn
import AuthenticationServices
import CryptoKit


class LoginScreenViewController: UIViewController {
    
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var soicalButtonsStackView: UIStackView!
    @IBOutlet weak var termOfPrivacyStackView: UIStackView!
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            loginButton.setImage(#imageLiteral(resourceName: "aa"), for: .normal)
        }
    }
    
    
    private func initlization() {
        setUpAppleButton()
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1),startPoint: nil,endPoint:nil)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        setUpBlackView()
    }
    
    
    private func setUpAppleButton() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(tapAppleButton), for: .touchUpInside)
        
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.topAnchor.constraint(equalTo: soicalButtonsStackView.bottomAnchor,constant: 10),
            appleButton.heightAnchor.constraint(equalToConstant: 40),
            appleButton.widthAnchor.constraint(equalTo: soicalButtonsStackView.widthAnchor),
            appleButton.bottomAnchor.constraint(equalTo: termOfPrivacyStackView.topAnchor, constant: -20)
        ])
        
    }
    
    
    @objc private func tapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    
    
    private func setUpBlackView(){
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        blackView.isHidden = true
        newtworkAlertView.isHidden = true
    }
    
    private func performLogin(){
        UserAPI.shard.login(userName: userNameTextField.text!, password: passwordTextField.text!) { (status, token, user, messages) in
            if status{
                if let user = user {
                    UserDefaultsData.shard.setToken(token: token)
                    UserDefaultsData.shard.saveUser(user: user)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarNav") as! UINavigationController
                    self.navigationController?.present(vc, animated: true, completion: nil)
                }
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
//                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func loginWithFacebook() {
        let loginManager = LoginManager()
        if let _ = AccessToken.current{
            loginManager.logOut()
        } else {
            loginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
                guard error == nil else {
                    GeneralActions.shard.showAlert(target:self,title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is an error in your login with facebook process", comment: ""))
                    return
                }
                guard let result = result, !result.isCancelled else {
                    return
                }
                
                if let token = AccessToken.current{
                    
                    let cardinate = FacebookAuthProvider.credential(withAccessToken: token.tokenString )
                    UserAPI.shard.signInWithCardinateInFirebase(cardinate: cardinate) { (status) in
                        
                        if status{
                            
                            self.getFacebookUserData { (status, id, name, email) in
                                
                                if status{
                                    
                                    UserAPI.shard.loginWithSoicalMedia(type: .facebook, email: email, id: id, name: name) { (status, user, messages, token) in
                                        
                                        if status{
                                            
                                            UserDefaultsData.shard.setToken(token: token)
                                            if let user = user {
                                                UserDefaultsData.shard.saveUser(user: user)
                                                UserAPI.shard.getProfileData { (status, messages, user) in
                                                    if status{
                                                        UserDefaultsData.shard.saveUser(user: user!)
                                                        if let _ = user!.gpsLat{
                                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarNav") as! UINavigationController
                                                            self.navigationController?.present(vc, animated: true, completion: nil)
                                                        }else{
                                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileNav") as! UINavigationController
                                                            self.navigationController?.present(vc, animated: true, completion: nil)
                                                        }
                                                    }else{
                                                        GeneralActions.shard.monitorNetwork {
                                                            DispatchQueue.main.async {
                                                                self.titleLabel.text = messages[0]
                                                                self.blackView.isHidden = false
                                                                self.newtworkAlertView.isHidden = false
                                                            }
                                                        } notConectedAction: {
                                                            DispatchQueue.main.async {
                                                                self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                                                                self.blackView.isHidden = false
                                                                self.newtworkAlertView.isHidden = false
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }else{
                                            GeneralActions.shard.monitorNetwork {
                                                DispatchQueue.main.async {
                                                    self.titleLabel.text = messages[0]
                                                    self.blackView.isHidden = false
                                                    self.newtworkAlertView.isHidden = false
                                                }
                                            } notConectedAction: {
                                                DispatchQueue.main.async {
                                                    self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                                                    self.blackView.isHidden = false
                                                    self.newtworkAlertView.isHidden = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            GeneralActions.shard.monitorNetwork(conectedAction: nil) {
                                DispatchQueue.main.async {
                                    self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                                    self.blackView.isHidden = false
                                    self.newtworkAlertView.isHidden = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func signInWithFacebook(_ sender: Any) {
        loginWithFacebook()
    }
    
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
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
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
    
}


// MARK: - Perform Login With Facebook
extension LoginScreenViewController{
    
    private func getFacebookUserData(callBack:@escaping (_ status:Bool,_ id:String,_ name:String,_ email:String)-> Void) {
        GraphRequest(graphPath: "me", parameters: ["fields":"email, id, name"]).start { (_, results, error) in
            if let _ = error{
                callBack(false,"","","")
                return
            }
            
            let res = results as! [String:Any] as NSDictionary
            let id = res.value(forKey: "id") as! String
            let fullName = res.value(forKey: "name") as! String
            let email = res.value(forKey: "email") as! String
            callBack(true,id,fullName,email)
        }
    }
    
}


extension LoginScreenViewController: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            guard let nonce = currentNonce else{
                ErrorAlertForAppleLogin()
                return
            }
            guard let appleIDToken = credentials.identityToken else{
                ErrorAlertForAppleLogin()
                return
            }
            guard let idTokenString = String(data: appleIDToken,encoding: .utf8) else {
                ErrorAlertForAppleLogin()
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            UserAPI.shard.signInWithCardinateInFirebase(cardinate: credential) { (status) in
                if status{
                    UserAPI.shard.loginWithSoicalMedia(type: .apple, email: credentials.email ?? "", id: credentials.user, name: credentials.fullName?.debugDescription ?? "") { (status, user, messages, token) in
                        if status{
                            
                        }else{
                            self.ErrorAlertForAppleLogin()
                        }
                    }
                }else{
                    self.ErrorAlertForAppleLogin()
                }
            }
            break
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
    
    
    private func ErrorAlertForAppleLogin(){
        GeneralActions.shard.showAlert(target: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is an error while you are signing in with apple", comment: ""))
    }
}

extension LoginScreenViewController: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}
