//
//  PopularFilmCollectionViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 28/01/2021.
//

import UIKit

class PopularFilmCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ivBackDrop: UIImageView!
    @IBOutlet weak var lblMovieTitle : UILabel!
    @IBOutlet weak var lblVoteCount : UILabel!
    @IBOutlet weak var ratingControlBar : RatingControl!
  
    
    
    var data : MovieResult?{
        didSet{
            if let data = data {
                let title  = data.title ?? data.originalName
                let backDropPath = "\(AppConstants.BASE_IMG_URL)/\( data.backdropPath ?? "")"
                lblMovieTitle.text = title
                ivBackDrop.sd_setImage(with: URL(string: backDropPath))
                
                let voteAverage = data.voteAverage ?? 0.0
                lblVoteCount.text  = "\(voteAverage)"
                ratingControlBar.starCount = 5
                ratingControlBar.rating = Int((voteAverage * 0.5))
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
