//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 25/01/2021.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var btnRateMovie: UIButton!

    @IBOutlet weak var ivBack: UIImageView!

    @IBOutlet weak var collectionViewAcotrs: UICollectionView!
    @IBOutlet weak var collectionViewProductionCompany: UICollectionView!
  
    @IBOutlet weak var collectionViewCreators: UICollectionView!
    
    @IBOutlet weak var lblMovieRelaeaseddate : UILabel!
    
    @IBOutlet weak var lblVoteCont : UILabel!
    @IBOutlet weak var lblVoteAverage : UILabel!
    @IBOutlet weak var ratingControl : RatingControl!
    @IBOutlet weak var lblMovieTitle : UILabel!
    @IBOutlet weak var lblMovieDuration : UILabel!
    @IBOutlet weak var lblMovieDescription : UILabel!
    @IBOutlet weak var lblAboutOriginalTitle : UILabel!
    @IBOutlet weak var lblAboutCollectionString : UILabel!
    @IBOutlet weak var lblAboutProductionCountry: UILabel!
    @IBOutlet weak var lblAboutPremiereDate : UILabel!
    @IBOutlet weak var lblAboutDescription : UILabel!
    @IBOutlet weak var ivMoviePoster : UIImageView!
    
    @IBOutlet weak var loadingView : UIActivityIndicatorView!
    @IBOutlet weak var overLayLodingUIView : UIView!
    
    var productionCompanyList = [ProductionCompany]()
    
    
    
    let networkAgent = MovieDBNetwrokingAgent.shared
    var movieID = -1
    var isSeries = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGestureForBackButton()
        loadingView.startAnimating()
        loadingView.hidesWhenStopped = true
        overLayLodingUIView.isHidden = false
        btnRateMovie.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnRateMovie.layer.borderWidth = 2
        btnRateMovie.layer.cornerRadius = 20
       
        //roundCornerBackDrop
        roundCornerBackDrop()
        registerForActorCollectionView()
        if(isSeries){
            fetchTVDetails(movieId: movieID)
        }else{
            fetchMovieDetails(movieId: movieID)
        }
       
    }
    fileprivate func roundCornerBackDrop(){
        ivMoviePoster.clipsToBounds = true
        ivMoviePoster.layer.cornerRadius = 16
        ivMoviePoster.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func  fetchTVDetails(movieId : Int)  {
        print("clicked : \(movieID)")
        networkAgent.getSeriesDetails(id: movieId) { (data) in
            //bind data
            self.bindData(data: data)
           
        } failure: { (error) in
            print(error)
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    func  fetchMovieDetails(movieId : Int)  {
        print("clicked : \(movieID)")
        networkAgent.getMovieDetails(id: movieId) { (data) in
            //bind data
            self.bindData(data: data)
           
        } failure: { (error) in
            print(error)
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    private func bindData(data : MovieDetailsResponse){
        //Production Company
        productionCompanyList = data.productionCompanies ?? [ProductionCompany]()
        collectionViewProductionCompany.reloadData()
        //ReleasedDate
        lblMovieRelaeaseddate.text = String(data.releaseDate?.split(separator: "-")[0] ?? data.firstAirDate?.split(separator: "-")[0] ?? "")
        //Votes
        lblVoteAverage.text = "\(data.voteCount ?? 0)"
        lblVoteCont.text = "\(data.voteAverage ?? 0.0) votes"
        //Title
        lblMovieTitle.text = data.title ?? data.originalName
        
        //Duration
        let runTimeHour = Int((data.runtime ?? 0)/60)
        let runTimeMinute = Int((data.runtime ?? 0)%60)
        lblMovieDuration.text = "\(runTimeHour) hr \(runTimeMinute) m"
        
        
        //Type
        
        var genreString : String = ""
        data.genres?.forEach({ genre in
            genreString = "\(genre.name ?? ""), "
        
        })
        if genreString != "" {
        genreString.removeLast()
        genreString.removeLast()
        }
        lblAboutCollectionString.text = genreString
        //OverView
        lblMovieDescription.text = data.overview ?? ""
        lblAboutDescription.text = data.overview
        lblAboutOriginalTitle.text = data.originalTitle ?? data.originalName
        lblAboutPremiereDate.text =  data.releaseDate ?? data.firstAirDate
        //Production Country
        var countryString = ""
        data.productionCountries?.forEach({ item in
            countryString += "\(item.name ?? ""), "
        })
        if countryString != "" {
        countryString.removeLast()
        countryString.removeLast()
        }
        lblAboutProductionCountry.text = countryString
        
       
        
        //Backdrop Image
        let backDropPath = "\(AppConstants.BASE_IMG_URL)/\( data.backdropPath ?? "")"
       ivMoviePoster.sd_setImage(with: URL(string: backDropPath))
        //Rating
        ratingControl.starCount = 5
        ratingControl.rating  = Int((data.voteAverage ?? 0.0) * 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingView.stopAnimating();            self.overLayLodingUIView.isHidden = true
        }
       
    }
    
    func initGestureForBackButton(){
       
        let tapGestureForBack = UITapGestureRecognizer(target: self, action: #selector(onTapBack))
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGestureForBack)
    }
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
    }
  
    
    private func registerForActorCollectionView(){
        collectionViewProductionCompany.dataSource = self
        collectionViewProductionCompany.delegate = self
        collectionViewProductionCompany.registerForCell(identifier: ProdcutionCompanyCollectionViewCell.identifier)
        
        collectionViewAcotrs.dataSource = self
        collectionViewAcotrs.delegate = self
        collectionViewAcotrs.registerForCell(identifier: BestActorsCollectionViewCell.identifier)
        
        collectionViewCreators.delegate = self
        collectionViewCreators.dataSource = self
        collectionViewCreators.registerForCell(identifier: BestActorsCollectionViewCell.identifier)
      
    }
    
    
}
extension MovieDetailsViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewProductionCompany{
            return productionCompanyList.count        }
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewProductionCompany{
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                    ProdcutionCompanyCollectionViewCell.identifier, for: indexPath) as? ProdcutionCompanyCollectionViewCell else {return UICollectionViewCell()}
            
                cell.data = productionCompanyList[indexPath.row]
                
                return cell
        }
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                             BestActorsCollectionViewCell.identifier, for: indexPath) as? BestActorsCollectionViewCell else {return UICollectionViewCell()}
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewProductionCompany{
            let width  = collectionView.frame.width / 2.5
            let height = width
            
            return CGSize(width: width, height: height)
        }
        return CGSize(width: collectionView.frame.width/2.5, height: CGFloat(180
    ))
    }
    
}
