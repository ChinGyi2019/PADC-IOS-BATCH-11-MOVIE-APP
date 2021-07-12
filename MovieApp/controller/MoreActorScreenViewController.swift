//
//  MoreActorScreenViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/07/2021.
//

import UIKit

class MoreActorScreenViewController: UIViewController {
    
    
    @IBOutlet weak var collectionViewActors : UICollectionView!
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 0.0, right: 0.0)
    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemPerRow = 3
    private var totalPages = 1
    private var currentPage = 1

    var initData : ActorListResponse?
    private let networkingAgent = MovieDBNetwrokingAgent.shared
    
    private var data:[ActorInfo] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        initState()
        
        navigationItem.title = "Who's Your Favourite"
       
    }
    
    fileprivate func initState(){
        currentPage = initData?.page ?? 1
        totalPages = initData?.totalPages ?? 1
        data.append(contentsOf: initData?.results ?? [ActorInfo]())
        collectionViewActors.reloadData()
    }
    
    fileprivate func registerCell(){
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        
        
        collectionViewActors.registerForCell(identifier: BestActorsCollectionViewCell.identifier)
        //Adding sectionInset for CollectionView
        let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
                layout.minimumLineSpacing = itemSpacing
                layout.minimumInteritemSpacing = itemSpacing
                self.collectionViewActors?.collectionViewLayout = layout
    }
    
    fileprivate func fetchActorList(page : Int){
        networkingAgent.getActorsList(page: page) { result in
            
            switch result{
            case .success(let data):
                self.data.append(contentsOf: data.results ?? [ActorInfo]())
                self.collectionViewActors.reloadData()
            case .failure(let error):
                print(error)
            }
            
           
        }

    }



}

extension MoreActorScreenViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifer: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as! BestActorsCollectionViewCell
        cell.data = data[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == (data.count - 1)
        let hasMorePage = currentPage < totalPages
        
        if isLastRow && hasMorePage {
            currentPage = currentPage + 1
            fetchActorList(page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        navigateToActorDetailsViewController(id: item.id ?? -1)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (2 * itemSpacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = collectionViewActors{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            let height = width * 1.5
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
