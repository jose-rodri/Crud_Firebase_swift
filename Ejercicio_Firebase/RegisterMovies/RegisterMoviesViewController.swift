//
//  RegisterMoviesViewController.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 25/11/21.
//

import UIKit
import DropDown
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class RegisterMoviesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageFirebase: UIImageView!
    @IBOutlet weak var textFieldID: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var buttonCategory: UIButton!

    
    
    
    var imagen: UIImage!
    let dropDownLibrary = DropDown()
    var type: String?
    var ref: DatabaseReference!
    var idUserFirebase = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCategory.addRightRegister(image: UIImage(named: "flecha1")!)
      
        
        
        ref = Database.database().reference()
        idUserFirebase = Auth.auth().currentUser!.uid
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        imageFirebase.addGestureRecognizer(tap)
    }
    

    
    @objc func tapAction(){
        
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = true
           present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       dropDownLibrary.direction = .bottom
       dropDownLibrary.anchorView = viewCategory
       dropDownLibrary.width = UIScreen.main.bounds.width - 50
       dropDownLibrary.bottomOffset = CGPoint(x: 0, y: viewCategory.bounds.height)
       dropDownLibrary.dataSource = ["Especialidad" , "MEDICINA FAMILIAR", "PEDIATRIA", "CIRUGIA", "CARDIOLOGIA", "NEUROLOGIA", "OFTALMOLOGIA"]
       dropDownLibrary.selectionAction = { [weak self] (index, item) in
           
           if index ==  0 {
              
           } else {
               self?.type = item
               self?.buttonCategory.setTitle(item, for: .normal)
           }
        
           
       }
       
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
 
       self.navigationController?.isNavigationBarHidden = false
    }
    
    
   
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagenTomada = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageFirebase.image = imagenTomada
        imagen = imagenTomada
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
    
        
        if imagen != nil {
            
      
       
        let id = ref.childByAutoId().key
        
        let storage = Storage.storage().reference()
        let nombreImagen = UUID()
        let directorio = storage.child("imagenes/\(nombreImagen)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        directorio.putData(imagen.pngData()!, metadata: metaData) { (data, error) in
            if error == nil {
                print("Cargo la imagen correctamente")
                self.hideLoader()
            } else {
                if let error = error?.localizedDescription {
                    print("Error al subir imagen en Firebase", error)
                } else {
                    print("Error en el código")
                }
            }
        }
        
        let campos = ["userId": textFieldID.text!,
                     "name" : textFieldName.text!,
                     "id":id,
                     "portada": String(describing: directorio)  ]
        
        print(campos)
        ref.child(idUserFirebase).child(type!).child(id!).setValue(campos)
        showLoader()
        
        clearTextFields()
        } else {
        print("Selecciona imagen")
            
            let viewController = DialogViewController()
            viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(viewController, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    func clearTextFields() {
        textFieldID.text = ""
        textFieldName.text = ""
    }
    
    
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDownLibrary.show()
       
    }
    
    
    @IBAction func showListButtonAction(_ sender: Any) {
        let HomeControllerV = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(HomeControllerV, animated: true)
    }
    
    @IBAction func btnCameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonCloseAction(_ sender: Any) {
    
        do {
            try  Auth.auth().signOut()
        } catch  {
            
        }
        
        
        let alert = UIAlertController(title: "Alerta", message: "Cerrar sesión", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
         
            self.navigationController?.popToRootViewController(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    
    }
    
}

extension UIView {
    
 
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}



