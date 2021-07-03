//
//  MovieSliderCollectionViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 24/01/2021.
//

import UIKit



class MovieSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivBackDrop: UIImageView!
    @IBOutlet weak var lblMovieTitle : UILabel!
  
    
    
    var data : MovieResult?{
        didSet{
            if let data = data {
                let title  = data.title
                let backDropPath = "\(AppConstants.BASE_IMG_URL)/\( data.backdropPath ?? "")" 
                lblMovieTitle.text = title
                ivBackDrop.sd_setImage(with: URL(string: backDropPath))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
