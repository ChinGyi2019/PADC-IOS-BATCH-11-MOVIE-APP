//
//  ShowCaseCollectionViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 30/01/2021.
//

import UIKit

class ShowCaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivBackDrop: UIImageView!
    @IBOutlet weak var lblMovieTitle : UILabel!
    @IBOutlet weak var lblReleasedDate : UILabel!
   
  
    
    
    var data : MovieResult?{
        didSet{
            if let data = data {
                let title  = data.title ?? data.originalName
                let backDropPath = "\(AppConstants.BASE_IMG_URL)/\( data.backdropPath ?? "")"
                lblMovieTitle.text = title
                ivBackDrop.sd_setImage(with: URL(string: backDropPath))
                lblReleasedDate.text = data.releaseDate
                
             
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
