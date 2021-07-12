//
//  GenreTableViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 30/01/2021.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewGenre: UICollectionView!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
//    let genreList  = [GenreVO(name : "ACTION", isSelected: true),GenreVO(name : "DRAMA", isSelected: false),GenreVO(name : "ADVENTURE && HHH", isSelected: false),GenreVO(name : "SIFI", isSelected: false),GenreVO(name : "ROMANCE", isSelected: false),GenreVO(name : "THRILLER", isSelected: false)]
    
    var allMovieAndSeries : [MovieResult]?{
        didSet{
            allMovieAndSeries?.forEach({ (movieSeries) in
                movieSeries.genreIDS?.forEach({ (genreId) in
                    let key = genreId
                    
                    if var _ = movieListByGenre[key]{
                        movieListByGenre[key]!.insert(movieSeries)
                    }else{
                        movieListByGenre[key] = [movieSeries]
                    }
                })
                
            })
            
            self.onTapMovie(genreId: genreList?.first?.id ?? 0)
        
        }
    }
    
 //   var movieList : [MovieResult] = []
    
    var selectedMovieList : [MovieResult] = []
    
    var movieListByGenre : [Int : Set<MovieResult>] = [:]
    
    var genreList : [GenreVO]?{
        didSet{
            if let _ = genreList{
                collectionViewGenre.reloadData()
                collectionViewMovie.reloadData()
                
                
                genreList?.removeAll(where: { genreVO -> Bool in
                    let genreID = genreVO.id
                    
                   let result = movieListByGenre.filter {(key, value) -> Bool in
                        genreID == key
                    }
                    
                    return result.count == 0
                })
                
                
            }
        }
    }
    
    var delegate : MovieItemDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate  = self
        
        collectionViewGenre.registerForCell(identifier: GenreCollectionViewCell.identifier)
    
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate  = self
        
        collectionViewMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension GenreTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView  == collectionViewMovie{
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
        }
            
        return CGSize(width: wordOfString(text: genreList?[indexPath.row].name ?? "",
                                          font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14))+30, height: 45)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewMovie{
            return selectedMovieList.count
        }
        return genreList?.count ?? 0
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let item = selectedMovieList[indexPath.row]
        if item.originalName != nil{
        
            delegate?.onTapMovie(id: item.id ?? -1, isSeries: true)
        }else{
            delegate?.onTapMovie(id: item.id ?? -1, isSeries: false)
        }
      
    }
    //Cell Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewMovie{
            
            let cell =  collectionView.dequeueCell(identifer: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = selectedMovieList[indexPath.row]
            return cell
        }
            
        guard let cell = collectionView.dequeueCell(identifer: GenreCollectionViewCell.identifier, indexPath: indexPath) as? GenreCollectionViewCell else {
                return UICollectionViewCell()
            }
     
        
        cell.data = genreList?[indexPath.row]
        
            cell.onTapItem = {genreId in
                debugPrint(genreId)
                
                self.onTapMovie(genreId: genreId)
            }
            
          
       
            return cell
        

        
    }
    
    fileprivate func onTapMovie(genreId : Int){
        self.genreList?.forEach{(genreVo) in
            
            if genreId == genreVo.id{
                genreVo.isSelected = true
                
            }else{
                genreVo.isSelected = false
            }
            
            let movieList = self.movieListByGenre[genreId]
            self.selectedMovieList = movieList?.map{return $0} ?? [MovieResult]()
        
            self.collectionViewGenre.reloadData()
            self.collectionViewMovie.reloadData()
            //After Click scrll to 0 position
            self.collectionViewMovie.scrollToTop(animated: true)
        }
    }
    
    func wordOfString(text : String,font : UIFont)->CGFloat{
        
        let fontAttributes = [NSAttributedString.Key.font : font]
        
        let textSize = text.size(withAttributes: fontAttributes)
        
        return textSize.width
        
    }
    
    
    
}

extension UIScrollView {
    func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: -contentInset.top),
                         animated: animated)
    }

    func scrollToBottom(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude),
                     animated: animated)
    }
}
