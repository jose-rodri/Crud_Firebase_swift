//
//  HomeViewController.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 8/11/21.
//

import UIKit
import Alamofire
import Firebase
import SwiftyJSON
class HomeViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var window: UIWindow?

    @IBOutlet weak var tableView: UITableView!
    
    var data:  [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        tableView.register(UINib(nibName: ListTableViewCell.cellType, bundle: nil), forCellReuseIdentifier: ListTableViewCell.cellType)
        dataWeb()
        tableView.rowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func dataWeb() {
        DispatchQueue.main.async {
         
            AF.request("https://private-45c58-alamofire9.apiary-mock.com/marvel")
              .validate()
              .responseDecodable(of: MoviesResponse.self) { (response) in
                guard let movies = response.value else { return }
                
                self.data = movies.data.users
                
                self.tableView.reloadData()
            
              }
            
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellType, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let getData = data[indexPath.row]
        
        
        if  indexPath.row % 2 == 0 {
            cell.displayCell(id: getData.id , name: getData.name, email: getData.email, index: indexPath.row, image: #imageLiteral(resourceName: "video") )
        } else {
            cell.displayCell(id: getData.id , name: getData.name, email: getData.email, index: indexPath.row, image: #imageLiteral(resourceName: "serie") )
        }
        
       
       


        return cell
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
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
        
     
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//              let initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
//              self.window?.rootViewController = initialViewController
        
        
    }
    
}
