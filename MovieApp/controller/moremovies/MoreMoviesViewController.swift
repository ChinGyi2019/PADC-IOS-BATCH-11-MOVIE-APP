//
//  MoreMoviesViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 09/07/2021.
//

import UIKit

class MoreMoviesViewController: UIViewController {

    @IBOutlet weak var collectionViewMovies: UICollectionView!
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 0.0, right: 0.0)
    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemPerRow = 3
    private var totalPages = 1
    private var currentPage = 1
    
    var movieOrSeries : MovieOrSeries = .movie

    var initData : MovieListResponse?
    private let networkingAgent = MovieDBNetwrokingAgent.shared
    
    private var data:[MovieResult] =  []
    var navigationTitle = "Explore Your Desires"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        initState()
        
        navigationItem.title = navigationTitle
       
    }
    
    fileprivate func initState(){
        currentPage = initData?.page ?? 1
        totalPages = initData?.totalPages ?? 1
        data.append(contentsOf: initData?.results ?? [MovieResult]())
        collectionViewMovies.reloadData()
    }
    
    fileprivate func registerCell(){
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        
        
        collectionViewMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        //Adding sectionInset for CollectionView
        let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
                layout.minimumLineSpacing = itemSpacing
                layout.minimumInteritemSpacing = itemSpacing
                self.collectionViewMovies?.collectionViewLayout = layout
    }
    
    fileprivate func setUpNetwrokCall(page : Int){
        switch movieOrSeries {
        case .movie:
            fetchMoivesList(page : page)
        case .series:
            fetchTvSeriesList(page : page)
        
    }
    }
    
    fileprivate func fetchMoivesList(page : Int){
        networkingAgent.getPopularMovieList(page: page) { result in
            
            switch result{
            case .success(let data):
                self.data.append(contentsOf: data.results ?? [MovieResult]())
                self.collectionViewMovies.reloadData()
                self.currentPage = data.page ?? 1
                self.totalPages = data.totalPages ?? 1
            case .failure(let error):
                print(error)
            }
            
           
        }

    }
    
    
    fileprivate func fetchTvSeriesList(page : Int){
        networkingAgent.getPopularSerieList(page: page) { result in
            
            switch result{
            case .success(let data):
                self.data.append(contentsOf: data.results ?? [MovieResult]())
                self.collectionViewMovies.reloadData()
                self.currentPage = data.page ?? 1
                self.totalPages = data.totalPages ?? 1
            case .failure(let error):
                print(error)
            }
            
           
        }

    }

}

extension MoreMoviesViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifer: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = data[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == (data.count - 1)
        let hasMorePage = currentPage < totalPages
        
        if isLastRow && hasMorePage {
            currentPage = currentPage + 1
            setUpNetwrokCall(page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        
        switch movieOrSeries {
        case .movie:
            navigateToMovieDetailsViewController(movieID: item.id ?? -1, isSeries: false)
        case .series:
            navigateToMovieDetailsViewController(movieID: item.id ?? -1, isSeries: true)
        }
      
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (2 * itemSpacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = collectionViewMovies{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            let height = width * 2
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}

