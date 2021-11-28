//
//  HomeController.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 25/11/21.
//
import DropDown
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class HomeController: UIViewController, UITableViewDelegate , UITableViewDataSource  {
   
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var viewEmpty: UIView!
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var listCategory = [CategoryResponse]()
    
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    let dropDownLibrary = DropDown()
    var categorySelect: String = ""
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        btnDrop.addRight(image: UIImage(named: "flecha1")!)
        
        self.title = "PEDIATRIA"
        tableView.rowHeight =  120
        viewEmpty.isHidden = true
        ref = Database.database().reference()
        
       /*
         [0:22, 27/11/2021] +51 941 172 224: agiladodelcarpio@hotmail.com
         [0:27, 27/11/2021] +51 941 172 224: CLAVE:agilado1998
         */
      
        guard let idFirebase = Auth.auth().currentUser?.uid else { return }
        
        handle = ref.child(idFirebase).child("PEDIATRIA").observe(DataEventType.value, with: { [self] (snapshot) in
            self.listCategory.removeAll()
            
            for item in snapshot.children.allObjects  as! [DataSnapshot] {
            
                let valores = item.value as? [String:AnyObject]
                let userID = valores?["userId"] as? String
                let name = valores?["name"] as? String
                let id = valores?["id"] as? String
                let url = valores?["portada"] as? String
                
                categorySelect = "PEDIATRIA"
                let categoryType =  CategoryResponse(userId: userID, name: name, id: id, imagen: url)
                listCategory.append(categoryType)
               
                
            }
            
            tableView.reloadData()
        
            if listCategory.count > 0 {
                viewEmpty.isHidden = true
            } else {
                viewEmpty.isHidden = false
            }
        
        })
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeCell.cellTypeHome, bundle: nil), forCellReuseIdentifier: HomeCell.cellTypeHome)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    
        guard let idFirebase = Auth.auth().currentUser?.uid else { return }
       
       dropDownLibrary.direction = .bottom
       dropDownLibrary.anchorView = btnDrop
       dropDownLibrary.width = UIScreen.main.bounds.width - 50
       dropDownLibrary.bottomOffset = CGPoint(x: 0, y: btnDrop.bounds.height)
       dropDownLibrary.dataSource = ["Especialidad" , "MEDICINA FAMILIAR", "PEDIATRIA", "CIRUGIA", "CARDIOLOGIA", "NEUROLOGIA", "OFTALMOLOGIA"]
       dropDownLibrary.selectionAction = { [weak self] (index, item) in
        self?.title = item
           if index ==  0 {
              
           } else {
             
            self?.btnDrop.setTitle(item, for: .normal)
            self?.categorySelect = item
            self?.handle = self?.ref.child(idFirebase).child(item).observe(DataEventType.value, with: { [self] (snapshot) in
                self?.listCategory.removeAll()
                
                for item in snapshot.children.allObjects  as! [DataSnapshot] {
                
                    let valores = item.value as? [String:AnyObject]
                    let userID = valores!["userId"] as? String
                    let name = valores!["name"] as? String
                    let id = valores!["id"] as? String
                    let url = valores?["portada"] as? String
                   
                    let categoryType =  CategoryResponse(userId: userID, name: name, id: id, imagen: url)
                    self?.listCategory.append(categoryType)
                   
                }
                self?.tableView.reloadData()
                if self?.listCategory.count ?? 0 > 0 {
                    self?.viewEmpty.isHidden = true
                } else {
                    self?.viewEmpty.isHidden = false
                }
            })
            
           }
        
           
       }
       
       
     
   }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.cellTypeHome, for: indexPath) as? HomeCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.lbl_userId.text = listCategory[indexPath.row].userId
        cell.lbl_name.text = listCategory[indexPath.row].name
        if let urlImage = listCategory[indexPath.row].imagen {
            Storage.storage().reference(forURL: urlImage).getData(maxSize: .max) { (data, error) in
                
                if let error = error?.localizedDescription {
                    print("Fallo al obtener la imagen", error)
                } else {
                    //cell.imageView?.image = UIImage(data: data! )
                    cell.ic_image?.image = UIImage(data: data! )
                }
                
            }
        }
        
        return cell
    }
    
    
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditVC" {
            
            if let id = tableView.indexPathForSelectedRow {
                let fila = listCategory[id.row]
                print(fila)
                let destino = segue.destination as! EditViewController
                destino.categoryResponse = fila
                destino.categoryType = categorySelect
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        let eliminar = UITableViewRowAction(style: .default, title: "Eliminar") { (action, indePath) in
            let eliminarCategoria: CategoryResponse
            eliminarCategoria = self.listCategory[indexPath.row]
            let id = eliminarCategoria.id
            let url = eliminarCategoria.imagen
            guard let idFirebase = Auth.auth().currentUser?.uid else { return }
            self.ref.child(idFirebase).child(self.categorySelect).child(id!).setValue(nil)
            let eliminarImagen = Storage.storage().reference(forURL: url!)
            eliminarImagen.delete(completion: nil)
        }
        
        return [eliminar]
        
    }
    
    
    
    
    @IBAction func listDropDown(_ sender: Any) {
        dropDownLibrary.show()
        
    }
    

}
