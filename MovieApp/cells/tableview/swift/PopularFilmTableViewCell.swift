//
//  PopularFilmTableViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 28/01/2021.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {
    @IBOutlet weak var popularFilmCollectionView: UICollectionView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblMoreMovies : UILabel!
    var delegate : MovieItemDelegate? = nil
    
    
    var data  = [MovieResult](){
        didSet{
            //if let _ = data{
                popularFilmCollectionView.reloadData()
          //  }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        popularFilmCollectionView.dataSource = self
        popularFilmCollectionView.delegate = self
        
        popularFilmCollectionView.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        
        lblMoreMovies.underLineText(text: "SEE MORE", stroke: 2)
        _ = UIColor(named: "primary_color")
        
    }
    
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PopularFilmTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        
        if item.originalName != nil{
            delegate?.onTapMovie(id: item.id ?? -1, isSeries: true)
        }else{
            delegate?.onTapMovie(id: item.id ?? -1, isSeries: false)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        
        let cell =  collectionView.dequeueCell(identifer: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: CGFloat(255))
    }
    
    
    
    
}
