//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 25/01/2021.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  
    
    //MARK: - IBoutlet
    @IBOutlet weak var btnRateMovie: UIButton!
    
    @IBOutlet weak var btnPlayTrailer: UIButton!
    @IBOutlet weak var ivBack: UIImageView!
    
    @IBOutlet weak var collectionViewAcotrs: UICollectionView!
    @IBOutlet weak var collectionViewProductionCompany: UICollectionView!
    
    @IBOutlet weak var collectionViewSimilarMovies: UICollectionView!
    
    @IBOutlet weak var uiViewAcotrs: UIView!
    @IBOutlet weak var uiProductionCompany: UIView!
    
    @IBOutlet weak var uiSimilarMovies: UIView!
    
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
    
    //MARK: - Variale
    private var movieCasts : [Cast] = []{
        didSet{
            print(movieCasts.count)
            if movieCasts.isEmpty{
                uiViewAcotrs.isHidden = true
            }
        }
    }
    private var similarMovies : [MovieResult] = []{
        didSet{
            if similarMovies.isEmpty{
                uiSimilarMovies.isHidden = true
            }
        }
    }
    private var productionCompanyList : [ProductionCompany] = []{
        didSet{
            if productionCompanyList.isEmpty{
                uiProductionCompany.isHidden = true
            }
        }
    }
    
    private var movieTrailers : [MovieTrailer] = []
    
    
    
    private let networkAgent = MovieDBNetwrokingAgent.shared
    var movieID = -1
    var isSeries = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        initGestureForBackButton()
        
        viewInit()
       
        
    }
    //MARK: - View Init
    fileprivate func viewInit(){
        btnInit()
        
        //roundCornerBackDrop
        roundCornerBackDrop()
        registerForActorCollectionView()
        if(isSeries){
            fetchTVDetails(movieId: movieID)
            fetchSeriesCasts(movieId: movieID)
        }else{
            fetchMovieDetails(movieId: movieID)
            fetchMovieCasts(movieId: movieID)
        }
       
        fetchSimilarMovies(movieId: movieID)
        fetchMovieTrailers(movieId: movieID)
    }
    fileprivate func btnInit(){
        btnRateMovie.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnRateMovie.layer.borderWidth = 2
        btnRateMovie.layer.cornerRadius = 20
        
        btnPlayTrailer.isHidden = false
    }
    fileprivate func roundCornerBackDrop(){
        
        loadingView.startAnimating()
        loadingView.hidesWhenStopped = true
        overLayLodingUIView.isHidden = false

    }
    
    private func registerForActorCollectionView(){
        collectionViewProductionCompany.dataSource = self
        collectionViewProductionCompany.delegate = self
        collectionViewProductionCompany.registerForCell(identifier: ProdcutionCompanyCollectionViewCell.identifier)
        collectionViewProductionCompany.showsHorizontalScrollIndicator = false
        collectionViewProductionCompany.showsVerticalScrollIndicator = false
        
        collectionViewAcotrs.dataSource = self
        collectionViewAcotrs.delegate = self
        collectionViewAcotrs.registerForCell(identifier: BestActorsCollectionViewCell.identifier)
        collectionViewAcotrs.showsHorizontalScrollIndicator = false
        collectionViewAcotrs.showsVerticalScrollIndicator = false
        
        collectionViewSimilarMovies.delegate = self
        collectionViewSimilarMovies.dataSource = self
        collectionViewSimilarMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        collectionViewSimilarMovies.showsHorizontalScrollIndicator = false
        collectionViewSimilarMovies.showsVerticalScrollIndicator = false
        
    }
    
    //MARK: - Business Logic
    func fetchMovieTrailers(movieId : Int)  {
        networkAgent.getMovieTrailer(id: movieID) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let data) :
                self.movieTrailers = data.results ?? [MovieTrailer]()
                self.btnPlayTrailer.isHidden = self.movieTrailers.isEmpty
            case .failure(let error) : print(error)
            }
            
            
            
        }
    }
    
    @IBAction func didTabPlayTrailer(_ sender : Any){
       
        let youtubeId = movieTrailers.first?.key ?? "invalid youtube key"
        
        navigateToYouTubeViewController(id: youtubeId)
    
       
    }
    
    
    func fetchSimilarMovies(movieId : Int)  {
        networkAgent.getSimilarMovies(id: movieID) { [weak self] (result) in
            guard let self = self else {return}
            
            switch result{
            case .success(let data):
                self.similarMovies = data.results ?? [MovieResult]()
                self.collectionViewSimilarMovies.reloadData()
            case .failure(let error):
                self.similarMovies =  [MovieResult]()
                print(error)
               
            }
            
          
        }
    }
    
    func  fetchMovieCasts(movieId : Int)  {
        networkAgent.getMoviesCredits(id: movieId) {[weak self] (result) in
            guard let self = self else {return}
            
            switch result{
            case .success(let data):
                self.movieCasts =  data.cast ?? [Cast]()
                self.collectionViewAcotrs.reloadData()
            case .failure(let error):
                print(error.description)
                self.movieCasts = [Cast]()
                self.collectionViewAcotrs.reloadData()
            }
          
        }
        
    }
    
    func  fetchSeriesCasts(movieId : Int)  {
        networkAgent.getSeriesCredits(id: movieId) {[weak self] (result) in
            guard let self = self else {return}
            
            switch result{
            case .success(let data):
                self.movieCasts =  data.cast ?? [Cast]()
                self.collectionViewAcotrs.reloadData()
            case .failure(let error):
                print(error.description)
                self.movieCasts = [Cast]()
                self.collectionViewAcotrs.reloadData()
            }
          
        }
        
    }
    
    
    
    func  fetchTVDetails(movieId : Int)  {
        
        networkAgent.getSeriesDetails(id: movieId) {[weak self] (result) in
            guard let self = self else {return}
            //bind data
            switch result{
            case .success(let movie):
                self.bindData(data: movie)
            case .failure(let error):
                print(error)
            }
            
            
        }
        
    }
    
    func  fetchMovieDetails(movieId : Int)  {
        
        networkAgent.getMovieDetails(id: movieId) {[weak self] (result) in
            guard let self = self else {return}
            //bind data
            switch result{
            case .success(let data):
                self.bindData(data: data)
            case .failure(let error):
                print(error)
            }
            
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
        //Navigation Title
        navigationItem.title = data.title ?? data.originalName
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else{return}
            self.loadingView.stopAnimating()
            self.overLayLodingUIView.isHidden = true
        }
        
    }
    
}
//MARK: - Extension
extension MovieDetailsViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewProductionCompany{
            return productionCompanyList.count
            
            
        }else if collectionView == collectionViewAcotrs{
            return movieCasts.count
        }else{
            return similarMovies.count
        }
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewProductionCompany{
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                    ProdcutionCompanyCollectionViewCell.identifier, for: indexPath) as? ProdcutionCompanyCollectionViewCell else {return UICollectionViewCell()}
            
            cell.data = productionCompanyList[indexPath.row]
            
            return cell
        }else if collectionView == collectionViewAcotrs{
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                    BestActorsCollectionViewCell.identifier, for: indexPath) as? BestActorsCollectionViewCell else {return UICollectionViewCell()}
            cell.ivActoryProfile.layer.cornerRadius = 8
            let result =  movieCasts[indexPath.row]
            cell.data = result.convertToActorInfo()
            
            return cell
        }else{
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                    PopularFilmCollectionViewCell.identifier, for: indexPath) as? PopularFilmCollectionViewCell else {return UICollectionViewCell()}
            cell.data = similarMovies[indexPath.row]
            // cell.delegate = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSimilarMovies{
            let item =  similarMovies[indexPath.row]
            navigateToMovieDetailsViewController(movieID: item.id ?? 1, isSeries: item.originalTitle?.isEmpty ?? false)
        }else if collectionView == collectionViewAcotrs{
            let item =  movieCasts[indexPath.row]
            navigateToActorDetailsViewController(id: item.id ?? -1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewProductionCompany{
            let width  = collectionView.frame.height
            let height = width
            
            return CGSize(width: width, height: height)
        }else if collectionView == collectionViewAcotrs{
            
            let width : CGFloat = 140 //collectionView.frame.width/2.5
            let height : CGFloat = width * 1.5
            
            
            return CGSize(width: width, height:height)
        }else{
            return CGSize(width: collectionView.frame.width/3, height: CGFloat(255))
        }
        
        
    }
    
}
