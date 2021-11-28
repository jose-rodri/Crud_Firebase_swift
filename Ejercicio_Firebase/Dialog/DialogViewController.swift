//
//  DialogViewController.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 27/11/21.
//

import UIKit

class DialogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
        
    }

    @objc func checkAction(sender : UITapGestureRecognizer) {
       self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
