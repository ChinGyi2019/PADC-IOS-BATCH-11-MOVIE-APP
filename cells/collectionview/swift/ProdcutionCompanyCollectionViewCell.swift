//
//  ProdcutionCompanyCollectionViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 24/06/2021.
//

import UIKit

class ProdcutionCompanyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivBackDrop: UIImageView!
    @IBOutlet weak var lblCompanyName : UILabel!
   
    
  
    
    
    var data : ProductionCompany?{
        didSet{
            if let data = data {
                let title  = data.name
                let backDropPath = "\(AppConstants.BASE_IMG_URL)/\( data.logoPath ?? "")"
                lblCompanyName.text = title
                ivBackDrop.sd_setImage(with: URL(string: backDropPath))
                
              
               
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
