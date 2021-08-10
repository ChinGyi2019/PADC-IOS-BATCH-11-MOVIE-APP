//
//  BestActorsTableViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 02/02/2021.
//

import UIKit

class BestActorsTableViewCell: UITableViewCell, ActorDelegate{
  
    
    var moreActorsDelegate : ShowMoreActorsDelegate? = nil
    var delegate : ActorItemDelegate? = nil
   
    func onTabLike(isLiked: Bool) {
        debugPrint("isLike \(isLiked)")
    }
    
    
    func onTabFavourite(isSelected: Bool) {
        debugPrint("isFavourite \(isSelected)")
    }
    
    var data = [ActorInfo](){
        didSet{
            collectionViewBestActors.reloadData()
            
        }
    }

    @IBOutlet weak var collectionViewBestActors: UICollectionView!
    @IBOutlet weak var lblMoreActors: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblMoreActors.underLineText(text: "MORE ACTORS", stroke: 2)
        
        collectionViewBestActors.dataSource = self
        collectionViewBestActors.delegate = self
        
        collectionViewBestActors.registerForCell(identifier: BestActorsCollectionViewCell.identifier)
     
        registerGestureRecognizer()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    fileprivate func registerGestureRecognizer(){
        let tapGestForFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapMoreActors) )
        lblMoreActors.isUserInteractionEnabled = true
        lblMoreActors.addGestureRecognizer(tapGestForFavorite)
        
    }
    
    @objc func onTapMoreActors(){
        moreActorsDelegate?.didTabMoreActors()
    }
    
}

extension BestActorsTableViewCell :  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width : CGFloat = 140 //ollectionView.frame.width/2.5
        let height : CGFloat = width * 1.5
            
        return CGSize(width: width, height:height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(identifer: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as? BestActorsCollectionViewCell else{
            return UICollectionViewCell()
        }
    
        cell.delegate = self
       
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        delegate?.didTabActor(id: item.id ?? -1)
        
        
    }
    
    
    
}
