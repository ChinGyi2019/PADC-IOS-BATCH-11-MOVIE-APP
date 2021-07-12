//
//  MoreShowCasesViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/07/2021.
//

import UIKit

class MoreShowCasesViewController: UIViewController {
    @IBOutlet weak var collectionViewShowCases : UICollectionView!
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.5, left: 4, bottom: 0.0, right: 0.0)
    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemPerRow = 3
    private var totalPages = 1
    private var currentPage = 1

    var initData : MovieListResponse?
    private let networkingAgent = MovieDBNetwrokingAgent.shared
    
    private var data:[MovieResult] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        initState()
       
    }
    
    fileprivate func initState(){
        currentPage = initData?.page ?? 1
        totalPages = initData?.totalPages ?? 1
        data.append(contentsOf: initData?.results ?? [MovieResult]())
        collectionViewShowCases.reloadData()
        navigationItem.title = "Explore Show Cases"
    }
    
    fileprivate func registerCell(){
        collectionViewShowCases.dataSource = self
        collectionViewShowCases.delegate = self
        
        
        collectionViewShowCases.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
    }
    
    fileprivate func fetchTopRatedMovieList(page : Int){
        networkingAgent.getTopRatedMovieList(page: page) { result in
            
            switch result{
            case .success(let data):
                self.data.append(contentsOf: data.results ?? [MovieResult]())
                self.collectionViewShowCases.reloadData()
            case .failure(let error):
                print(error)
            }
            
        } 

    }



}

extension MoreShowCasesViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifer: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as! ShowCaseCollectionViewCell
        cell.data = data[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == (data.count - 1)
        let hasMorePage = currentPage < totalPages
        
        if isLastRow && hasMorePage {
            currentPage = currentPage + 1
            fetchTopRatedMovieList(page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        navigateToMovieDetailsViewController(movieID: item.id ?? -1, isSeries: item.originalTitle?.isEmpty ?? false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * 4
//        let availableWidth = view.frame.width - paddingSpace - (sectionInsets.top * 4) -  (sectionInsets.right * 4) -  (sectionInsets.bottom * 4)
        
        let widthPerItem  = collectionView.frame.width - (sectionInsets.left * 4)
        let height = widthPerItem * 0.5


        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
