//
//  EditViewController.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 26/11/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import GoogleSignIn
import FirebaseAuth

class EditViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var ic_Image: UIImageView!
    
    var categoryResponse: CategoryResponse!
   
    var imageData: String = ""
    var id: String? = nil
    var categoryType: String? = nil
    var ref: DatabaseReference!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtuserId: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
   
    
    
    
    var portada = ""
    var imagen: UIImage!
    var categorySelect: String = ""
    
    var idFirebase = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = categoryType
        idFirebase = Auth.auth().currentUser!.uid
        //navigationItem.hidesBackButton = true
       //  GIDSignIn.sharedInstance()?.signOut()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        ic_Image.addGestureRecognizer(tap)
       // ic_Image.makeRounded()
    
        btnEdit.isEnabled = false
        btnEdit.alpha = 0.5
        
        ref = Database.database().reference()
        
        txtuserId.text = categoryResponse.userId!
        txtName.text = categoryResponse.name!
        id = categoryResponse.id!
        imageData = categoryResponse.imagen!
        
        portada = categoryResponse.imagen!
      
    
       
        Storage.storage().reference(forURL: imageData).getData(maxSize: .max) { (data, error) in
            
            if let error = error?.localizedDescription {
                print("Fallo al obtener la imagen", error)
            } else {
                self.ic_Image.image = UIImage(data: data!)
               
              
               
                
            }
            
        }
    }
    

    @objc func tapAction(){
        btnEdit.isEnabled = true
        btnEdit.alpha = 0.9
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addImageAction(_ sender: Any) {
        btnEdit.isEnabled = true
        btnEdit.alpha = 0.9
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnAditButtonAction(_ sender: Any) {
        
        let storage = Storage.storage().reference()
        let nombreImagen = UUID()
        let directorio = storage.child("imagenes/\(nombreImagen)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        
        
        directorio.putData(imagen.pngData()!, metadata: metaData) { [self] (data, error) in
            if error == nil {
                
              
                let eliminarImagen = Storage.storage().reference(forURL: portada)
                eliminarImagen.delete(completion: nil)
               
                let campos = ["userId": txtuserId.text!,
                              "name": txtName.text! ,
                              "id": id ,
                              "portada" : String(describing: directorio)]
                
                ref.child(self.idFirebase).child(categoryType!).child(id!).setValue(campos)
                
               
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    hideLoader()
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                if let error = error?.localizedDescription {
                    print("Error al subir imagen en Firebase", error)
                } else {
                    print("Error en el código")
                }
            }
        }
        
        
        
        showLoader()
       
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagenTomada = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        print(imagenTomada)
        ic_Image.image = imagenTomada
        imagen = imagenTomada
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
