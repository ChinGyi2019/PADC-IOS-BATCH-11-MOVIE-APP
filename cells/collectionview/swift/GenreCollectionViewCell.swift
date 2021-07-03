//
//  GenreCollectionViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 30/01/2021.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containreView: UIView!
    
    @IBOutlet weak var lblGenre: UILabel!
    
    @IBOutlet weak var viewForOverLay: UIView!
    
    var onTapItem : ((Int)->Void) = {_ in }
    
    var data : GenreVO? = nil {
        didSet{
            
            if let genre = data{
                lblGenre.text = genre.name.uppercased()
                if (genre.isSelected) {
                    lblGenre.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    (viewForOverLay.isHidden = false)
                }else{
                    lblGenre.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    (viewForOverLay.isHidden = true)
                    
                }
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureForContainer = UITapGestureRecognizer(target: self, action: #selector(didTabItem))
        containreView.isUserInteractionEnabled = true
        containreView.addGestureRecognizer(tapGestureForContainer)
        
    }
    
    @objc func didTabItem(){
        onTapItem(data?.id ?? 0)
        
    }
    

}
