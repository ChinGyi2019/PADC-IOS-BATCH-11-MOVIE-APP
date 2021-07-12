//
//  MovieSliderTableViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 24/01/2021.
//

import UIKit

class MovieSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var movieSliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var delegate : MovieItemDelegate? = nil
    var data : MovieListResponse?{
        didSet{
            if let _ = data{
                pageControl.numberOfPages = data?.results?.count ?? 0
                movieSliderCollectionView.reloadData()
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieSliderCollectionView.dataSource = self
        movieSliderCollectionView.delegate = self
    
        movieSliderCollectionView.registerForCell(identifier: MovieSliderCollectionViewCell.identifier)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MovieSliderTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: CGFloat(240))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.results?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell =  collectionView.dequeueCell(identifer: MovieSliderCollectionViewCell.identifier, indexPath: indexPath) as! MovieSliderCollectionViewCell
        cell.data =  data?.results?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?.results?[indexPath.row]
        delegate?.onTapMovie(id: item?.id ?? -1, isSeries: false)
       
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width)
    
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width)
    }
    
    
}
