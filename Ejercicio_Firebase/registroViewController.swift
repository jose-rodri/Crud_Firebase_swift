//
//  registroViewController.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 7/11/21.
//

import UIKit
import DropDown
import FirebaseAuth
import Firebase

enum selectTypeUser : String {
    case paciente = "PACIENTE"
    case medico = "MEDICO"
}

protocol dataRegisterProtocol: class {
    var name: String? { get set }
    var typeRegister: String? { get set }
    var email: String? { get set }
   
}

class registroViewController: UIViewController,dataRegisterProtocol {
    var name: String?
    var typeRegister: String?
    var email: String?
   
    @IBOutlet weak var label_full_name: UITextField!
    @IBOutlet weak var label_email: UITextField!
    @IBOutlet weak var label_password: UITextField!
    
    @IBOutlet weak var label_confirmar: UITextField!

    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    
    
    let dropDownLibrary = DropDown()
    var type: String?
    
    
    var delegateDta: dataRegisterProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        btnCreate.layer.cornerRadius = 20
        btnCreate.clipsToBounds = true
    }
    
    var checkBoxBtn: Bool = false
    
    var typeUser: String = ""
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
    }
    
    
    
   
    
    @IBAction func btn1Action(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            btn2.isSelected = false
            
            typeUser = selectTypeUser.paciente.rawValue
        } else {
            sender.isSelected = true
            btn2.isSelected = false
          
            typeUser = selectTypeUser.medico.rawValue
        }
      
    }
    
    @IBAction func btn2Action(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            btn1.isSelected = false
          
        } else {
            
            btn1.isSelected = false
            sender.isSelected = true
        }
        
    }
    
    
   
    @IBAction func registerAction(_ sender: Any) {
        let correo =  label_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = label_full_name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = label_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if typeUser == "" {
            let alert = UIAlertController(title: "Alerta", message: "Seleccione tipo de usuario a registrar", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
              }))

            alert.addAction(UIAlertAction(title: "cancelar", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: correo, password: password) { (user, error) in
                if user != nil {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["full_name" : name , "type" : self.typeUser , "uid": user!.user.uid ]) { (error) in
                        if error != nil {
                            
                        } else {

                        
                            self.showToast(message: "Usuario creado.. !!!")
                           
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                                self.delegateDta?.typeRegister =  self.type
                                self.delegateDta?.email = correo
                                self.delegateDta?.name = name
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            
                        }
                        
                    }
                    
                    
                } else {
                    if let error = error?.localizedDescription {
                        print("Error firebase de registro" , error)
                    } else {
                        print("Error en código")
                    }
                }
            }
        }
       
        
        
    }
    
    
    @IBAction func logInAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
