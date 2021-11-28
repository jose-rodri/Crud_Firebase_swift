//
//  ViewController.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 7/11/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
class ViewController: UIViewController , dataRegisterProtocol, GIDSignInDelegate {
  
    var name: String?
    var typeRegister: String?
    var email: String?
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var labelDescriptio: UILabel!
  
    @IBOutlet weak var fbView: UIView!
    
  
    @IBOutlet weak var btnSignGoogle: GIDSignInButton!
    
    var nameGoogle: String?
    var emailGoogle: String?
    var imageGoogle: URL?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUser.text = "magic@gmail.com"
        txtPassword.text = "123456"
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    
     
        if (AccessToken.current != nil) {
            
        }
     
    
        
        txtUser.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let image = UIImage(named: "correo.png")
        imageView.image = image
        txtUser.leftView = imageView
        
        txtPassword.leftViewMode = UITextField.ViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let image2 = UIImage(named: "llave.png")
        imageView2.image = image2
        txtPassword.leftView = imageView2
        
        
        
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
    
    }
    
    func facebookButton(){
        // Login Button made by Facebook
             let loginButton = FBLoginButton()
             // Optional: Place the button in the center of your view.
             loginButton.permissions = ["public_profile", "email"]
             loginButton.center = fbView.center
             loginButton.delegate = self
        fbView.addSubview(loginButton)
    }
    

    @IBAction func btnAction(_ sender: Any) {
        let User = txtUser.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        initSession(correo: User, password: Password)
    }

    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "loginRegister" {
             let secondVC: registroViewController = segue.destination as! registroViewController
             secondVC.delegateDta = self
         }
     }
  
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
  
        if let error = error {
            print("Error en el login ", error.localizedDescription)
        } else {
            nameGoogle = user.profile.name
            emailGoogle = user.profile.email
            
           
//            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
//
//            Auth.auth().signIn(with: credential) { (result, error) in
//
//                let registerMovie = self.storyboard?.instantiateViewController(withIdentifier: "RegisterMoviesViewController") as! RegisterMoviesViewController
//                self.navigationController?.pushViewController(registerMovie, animated: true)
//
//            }
            
            
       
            
            Auth.auth().createUser(withEmail: emailGoogle!, password: "123456") { (user, error) in
                if user != nil {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["full_name" : self.nameGoogle! , "type" : "TERROR" , "uid": user!.user.uid ]) { (error) in
                        if error != nil {
                            print("El usuario adicional no se puedo crear")
                        } else {
                            print("Usuarios agregado correctamnte")
                            self.initSession(correo: self.emailGoogle!, password: "123456")
                        }
                        
                    }
                } else {
                    if let error = error?.localizedDescription {
                        self.initSession(correo: self.emailGoogle!, password: "123456")
                        print("Error firebase de registro..." , error)
                    } else {
                        print("Error en código")
                    }
                }
                
        }
            
            
            
        }
            
            
    }
    
    
    
    
    func initSession(correo: String , password: String) {

        Auth.auth().signIn(withEmail: correo, password: password) { [self] (user, error) in
            
            if user != nil {
                
                let registerMovie = self.storyboard?.instantiateViewController(withIdentifier: "RegisterMoviesViewController") as! RegisterMoviesViewController
                self.navigationController?.pushViewController(registerMovie, animated: true)
            
            } else {
                if let error = error?.localizedDescription {
                    
                    
                    let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) in
                    print("ok")
                    }))
                    self.present(alert, animated: true)
                    
                    
                } else {
                    print("Error en código")
                }
            }
        }
        
      
    }
    
    func ad(data: dataRegisterProtocol) {
        
    }

    @IBAction func registerAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "loginRegister", sender: self)
    }
    
}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if result?.isCancelled ?? false {
            print("Cancelled")
        } else if error != nil {
            print("ERROR: Trying to get login results")
        } else {
            print("Logged in")
            self.getUserProfile(token: result?.token, userId: result?.token?.userID)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Do something after the user pressed the logout button
        print("You logged out!")
    }
    func getUserProfile(token: AccessToken?, userId: String?) {
            let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
            graphRequest.start { _, result, error in
                if error == nil {
                    let data: [String: AnyObject] = result as! [String: AnyObject]
                    
                    // Facebook Id
                    if let facebookId = data["id"] as? String {
                        print("Facebook Id: \(facebookId)")
                    } else {
                        print("Facebook Id: Not exists")
                    }
                    
                    // Facebook First Name
                    if let facebookFirstName = data["first_name"] as? String {
                        print("Facebook First Name: \(facebookFirstName)")
                    } else {
                        print("Facebook First Name: Not exists")
                    }
                    
                    // Facebook Middle Name
                    if let facebookMiddleName = data["middle_name"] as? String {
                        print("Facebook Middle Name: \(facebookMiddleName)")
                    } else {
                        print("Facebook Middle Name: Not exists")
                    }
                    
                    // Facebook Last Name
                    if let facebookLastName = data["last_name"] as? String {
                        print("Facebook Last Name: \(facebookLastName)")
                    } else {
                        print("Facebook Last Name: Not exists")
                    }
                    
                    // Facebook Name
                    if let facebookName = data["name"] as? String {
                        print("Facebook Name: \(facebookName)")
                    } else {
                        print("Facebook Name: Not exists")
                    }
                    
                    // Facebook Profile Pic URL
                    let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                    print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                    
                    // Facebook Email
                    if let facebookEmail = data["email"] as? String {
                        print("Facebook Email: \(facebookEmail)")
                    } else {
                        print("Facebook Email: Not exists")
                    }
                    
                    print("Facebook Access Token: \(token?.tokenString ?? "")")
                } else {
                    print("Error: Trying to get user's info")
                }
            }
        }
}
