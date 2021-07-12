//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/07/2021.
//

import UIKit

class SearchMovieViewController: UIViewController {
    @IBOutlet weak var collectionViewSearchMovie : UICollectionView!
    private var movieSearchBar =  UISearchBar()
    
  
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 0.0, right: 0.0)
    
    private let itemSpacing : CGFloat = 16
    private let numberOfItemPerRow = 3
    private var totalPages = 1
    private (set) var currentPage = 1
    private var searhQuery : String? = ""
    private var currentQuery : String? = ""

    var initData : MovieListResponse?
    private let networkingAgent = MovieDBNetwrokingAgent.shared
    
   // private var data : Set<MovieResult> = []
    private var data : [MovieResult] = []
    private var searchWaitTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        initState()
    
        changeSearchBarTextColor()
       
    }
    
    fileprivate func changeSearchBarTextColor(){
//        let textFieldInsideSearchBar = movieSearchBar.value(forKey: "searchField") as? UITextField
//
//        textFieldInsideSearchBar?.textColor = UIColor.white
        movieSearchBar.placeholder = "Search..."
        movieSearchBar.searchTextField.textColor = .white
        movieSearchBar.delegate = self
        navigationItem.titleView = movieSearchBar
    
    }
    
    private func resetValues() {
        currentPage = 1
        totalPages = 1
        //Here to reset searchResult.value.removeAll()
        data.removeAll()
        searchWaitTimer?.invalidate()
        collectionViewSearchMovie.reloadData()
    }
    
    fileprivate func initState(){
        currentPage = initData?.page ?? 1
        totalPages = initData?.totalPages ?? 1
    
    }
    
    fileprivate func registerCell(){
        collectionViewSearchMovie.dataSource = self
        collectionViewSearchMovie.delegate = self
        
        
        collectionViewSearchMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
                layout.minimumLineSpacing = itemSpacing
                layout.minimumInteritemSpacing = itemSpacing
                self.collectionViewSearchMovie?.collectionViewLayout = layout

    }
    
    fileprivate func fetchSearchMovies(searchQuery : String, page : Int){
        print(page)
        networkingAgent.getSearchedMovieList(searchQuery : searchQuery, page: page) { result in
            
            switch result{
            case .success(let data):
//                data.results?.forEach({ movie in
//                    self.data.insert(movie)
//                })
                self.data.append(contentsOf: data.results ?? [MovieResult]())
                self.collectionViewSearchMovie.reloadData()
                self.currentPage = data.page ?? 1
                self.totalPages = data.totalPages ?? 1
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    fileprivate func performSearch(searchQuery : String?, page : Int){
        if currentQuery != searchQuery{
            resetValues()
            currentQuery = searchQuery

        }else{
            fetchSearchMovies(searchQuery: searchQuery ?? "", page: page)
            
            
        }
    }
    
   fileprivate func searchDidBeginEditing(query: String?) {
        if query == nil || query?.isEmpty == true {
            resetValues()
        }
    }



}

extension SearchMovieViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifer: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
      //  let movieList = data.map { return $0}
        cell.data = data[indexPath.row]
            
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == (data.count - 1)
        let hasMorePage = currentPage < totalPages
        
        if isLastRow && hasMorePage {
            currentPage = currentPage + 1
            movieSearchBar.resignFirstResponder()
            guard let query = movieSearchBar.text else {return}
            performSearch(searchQuery: query, page: currentPage)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let movieList = data.map { return $0}
        let item = data[indexPath.row]
        navigateToMovieDetailsViewController(movieID: item.id ?? -1, isSeries: item.originalTitle?.isEmpty ?? false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (2 * itemSpacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = collectionViewSearchMovie{
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
    




extension SearchMovieViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Call network Searching
        
        searhQuery = searchBar.text
        
        searchWaitTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {[weak self] _ in
            self?.performSearch(searchQuery: searchBar.text ?? "", page: self?.currentPage ?? 1)
        })

       

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchDidBeginEditing(query: searchBar.text)
        movieSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        //Resign Intitial State
        resetValues()
        searchBar.setShowsCancelButton(false, animated: true)
     //   searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.resignFirstResponder()
        performSearch(searchQuery: searchBar.text, page: currentPage)
    }
}
