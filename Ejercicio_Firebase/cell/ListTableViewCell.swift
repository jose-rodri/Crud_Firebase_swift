//
//  ListTableViewCell.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 7/11/21.
//

import UIKit
import AlamofireImage
class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelSubtitle: UILabel!
    
    @IBOutlet weak var viewNumber: UIView!
    @IBOutlet weak var labelValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCellShadow()
    }

    
    private func addCellShadow() {
        mView.layer.cornerRadius = 8.0
        mView.layer.shadowColor = UIColor.gray.cgColor
        mView.layer.shadowOffset = CGSize.zero
        mView.layer.cornerRadius = 8.0
        mView.layer.shadowOpacity = 1.9
        viewNumber.layer.cornerRadius = viewNumber.layer.bounds.width / 2
        viewNumber.backgroundColor = .yellow
        viewNumber.clipsToBounds = true
       }
    
    static var cellType: String {
        return String(describing: self)
    }
       
    //    let id, name, email: String
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displayCell(id: String , name: String, email: String, index: Int , image: UIImage ) {
        
        /*
        let downloader = ImageDownloader()
        let urlRequest = URLRequest(url: URL(string: "https://httpbin.org/image/jpeg")!)
        downloader.download(urlRequest, completion:  { response in
            if case .success(let image) = response.result {
              
                self.icon.image = image
            }
        })
        */
        
        labelValue.text =  "\(index)"
        if index % 2 == 0  {
            print(index)
            labelTitle.text = name
            labelSubtitle.text = email
            icon.image = image
            
        } else {
            print(index)
            labelTitle.text = name
            labelSubtitle.text = email
            icon.image = image
        }
        
    }
}

