//
//  ActorDetailsViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/07/2021.
//

import UIKit
import SDWebImage

class ActorDetailsViewController: UIViewController{
    //MARK: - IBoutlet
    @IBOutlet weak var readMoreBtnStackView : UIStackView!
    @IBOutlet weak var lblActorName: UILabel!
    @IBOutlet weak var lblDateofBirth: UILabel!
    @IBOutlet weak var lblBiography: DynamicLabel!
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var ivActorBackDrop: UIImageView!
    
    private let networkingAgent = MovieDBNetwrokingAgent.shared
    private let actorModel = ActorModelImpl.shared
    private var credits : [MovieResult] = []
    private var homeURL : String = ""
    
    var actorID : Int = -1
    
    @IBAction func didTabCloseBtn(_ sender : Any){
        actorID = -1
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBOutlet weak var collectionViewCredits: UICollectionView!
    
    //Mark: - viewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        fetchActorDetails(id: actorID)
        fetchActorCombinedCredits(id: actorID)
        gestureForLblBiography()

        
    }
    //MARK: - ViewInit
    fileprivate func registerCell(){
        collectionViewCredits.dataSource = self
        collectionViewCredits.delegate = self
        
        
        collectionViewCredits.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    //MARK: - Business Logic
    fileprivate func fetchActorDetails(id : Int){
        actorModel.getActorDetails(id: id) { [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let data):
                self.bindView(data: data)
            case .failure(let error):
                print(error)
            }
        }

    }
    
    fileprivate func fetchActorCombinedCredits(id : Int){
        actorModel.getActorCombinedCredits(id: id) {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let data):
                self.credits = data 
                self.collectionViewCredits.reloadData()
            case .failure(let error):
                print(error)
            }
            
        }

    }
    
    fileprivate func bindView(data : ActorDetailsResponse){
        //NavigationItem
        navigationItem.title = data.name
        lblActorName.text = data.name
        if(data.biography?.isEmpty == false && data.biography != nil){
            lblBiography.fullText = data.biography ?? " "
            lblBiography.collapse()
        }
        
      //  lblBiography.text = data.biography
        lblDateofBirth.text = data.birthday
        let backDropPath = "\(AppConstants.BASE_IMG_URL)/\( data.profilePath ?? "")"
       
        ivActorBackDrop.sd_setImage(with: URL(string: backDropPath))
        homeURL = data.homepage ?? ""
        readMoreBtnStackView.isHidden = data.homepage?.isEmpty ?? true || data.homepage == nil
    }
    
    //MARK: - Gesture For Biography
    fileprivate func gestureForLblBiography(){
        let gestureForlblBiography = UITapGestureRecognizer(target: self, action: #selector(onTaplblBioGraphy))
        lblBiography.isUserInteractionEnabled = true
        lblBiography.addGestureRecognizer(gestureForlblBiography)
    }
    
    @objc func onTaplblBioGraphy(){
        if lblBiography.isTruncated{
            lblBiography.expand()
           
        }else{
            lblBiography.collapse()
        }
        
    }
    
    @IBAction func didTabReadMoreBtn(_ sender : Any){
        
        
        if let url = URL(string: homeURL), UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
              UIApplication.shared.openURL(url)
           }
        }
    }

}
//MARK: - Delegate & DataSource
extension ActorDetailsViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credits.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = credits[indexPath.row]
        navigateToMovieDetailsViewController(movieID: item.id ?? -1, isSeries: item.originalTitle?.isEmpty == true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifer: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data =  credits[indexPath.row]
        
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
    }

    
}
