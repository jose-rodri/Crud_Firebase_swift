//
//  HomeCell.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 25/11/21.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var lbl_userId: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var ic_image: UIImageView!
    @IBOutlet weak var mView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addCellShadow() 
    }

    static var cellTypeHome: String {
        return String(describing: self)
    }
    private func addCellShadow() {
        mView.layer.cornerRadius = 8.0
        mView.layer.shadowColor = UIColor.gray.cgColor
        mView.layer.shadowOffset = CGSize.zero
        mView.layer.cornerRadius = 8.0
        mView.layer.shadowOpacity = 1.9
        
//        ic_image.layer.cornerRadius = ic_image.layer.bounds.width / 2
//        ic_image.clipsToBounds = true
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
