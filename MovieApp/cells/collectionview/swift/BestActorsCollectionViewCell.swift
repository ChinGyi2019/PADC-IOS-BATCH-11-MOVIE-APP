//
//  BestActorsCollectionViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 02/02/2021.
//

import UIKit
import SDWebImage




class BestActorsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivLike: UIImageView!
   
    @IBOutlet weak var ivUnLike: UIImageView!
    
    @IBOutlet weak var ivHeartFill: UIImageView!
    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var lblActorName : UILabel!
    @IBOutlet weak var lblKnownForDepartment : UILabel!
    @IBOutlet weak var ivActoryProfile : UIImageView!
    
    var delegate : ActorDelegate? = nil
    
    
    var data : ActorInfo?{
        didSet{
            if var _ = data{
                lblActorName.text = data?.name
                lblKnownForDepartment.text = data?.knownForDepartment
                let backDropPath = "\(AppConstants.BASE_IMG_URL)/\( data?.profilePath ?? "")"
                
                ivActoryProfile.sd_setImage(with: URL(string: backDropPath))
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initGestureRecognizer()
        
        
    }
    
    private func initGestureRecognizer(){
    
        let tapGestForFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapFavourite) )
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestForFavorite)
        
        let tapGestForUnFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapUnFavorite) )
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestForUnFavorite)
        
        let tapGestForLike = UITapGestureRecognizer(target: self, action: #selector(onTapLike) )
        ivLike.isUserInteractionEnabled = true
        ivLike.addGestureRecognizer(tapGestForLike)
        
        let tapGestForUnLike = UITapGestureRecognizer(target: self, action: #selector(onTapUnLike) )
        ivUnLike.isUserInteractionEnabled = true
        ivUnLike.addGestureRecognizer(tapGestForUnLike)
    }
    
    
    @objc func onTapFavourite(){
        ivHeartFill.isHidden  = true
        ivHeart.isHidden = false
        delegate?.onTabFavourite(isSelected: true)
    }
    
    @objc func onTapUnFavorite(){
        ivHeartFill.isHidden  = false
        ivHeart.isHidden = true
        delegate?.onTabFavourite(isSelected: false)
    }
    
    @objc func onTapLike(){
        ivLike.isHidden  = true
        ivUnLike.isHidden = false
        delegate?.onTabFavourite(isSelected: true)
    }
    
    @objc func onTapUnLike(){
        ivLike.isHidden  = false
        ivUnLike.isHidden = true
        delegate?.onTabFavourite(isSelected: false)
    }

}
