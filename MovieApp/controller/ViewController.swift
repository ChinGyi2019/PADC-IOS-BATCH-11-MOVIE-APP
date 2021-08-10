//
//  ViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 24/01/2021.
//

import UIKit

class ViewController: UIViewController , MovieItemDelegate, ActorItemDelegate, ShowMoreActorsDelegate, ShowMoreShowCasesDelegate{
    
    //MARK:- Navigation Method
    func didTabMoreShowCases() {
        navigateToShowMoreShowCasesViewController(movies: topRatedMovieList)
    }
    
    func didTabMoreActors() {
        navigateToShowMoreActorsViewController(initActors: actorList)
    }
    
    func didTabActor(id: Int) {
        print(id)
        navigateToActorDetailsViewController(id: id)
    }
    
    //MARK:- IBOutlet
    @IBAction func onTapSearchImageIcon(_ sender : Any){
        navigateToSearchMovieViewController()
    }
    
    @IBOutlet weak var movieHostTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    
    
    //MARK:- Properties
    private var upCommingMovieList  =  [MovieResult]()
    private var popularMovieList  =  [MovieResult]()
    private var popularSeriesList  =  [MovieResult]()
    private var topRatedMovieList  = [MovieResult]()
    private var actorList = [ActorInfo]()
    private var genreList = [MovieGenre]()
    private var actorListResponse  :ActorListResponse? = nil
    private var movieListResponse : MovieListResponse? = nil
    private var popularMovieListResponse =  [MovieResult]()
    private var popularSeriesListResponse =  [MovieResult]()
    private let movieModel : MovieModel = MovieModelImpl.shared
    private let actorModel : ActorModel = ActorModelImpl.shared
    private let movieModelWithURLSession = NetworkAgentWithURLSession.shared
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        movieHostTableView.dataSource = self
        if #available(iOS 14.0, *) {
            navigationItem.backBarButtonItem = UIBarButtonItem(title : "")
        } else {
            
        }
    
        initView()
        
    }
    
    
    //MARK:- View Init
    
    private func initView(){
        //Registering
        registerTableViewCell()
        
        handleRefreshControl()
        //Call Network
        callNetwork()
       
    }
    
    private func registerTableViewCell(){
        
        movieHostTableView.registerForCell(identifier:MovieSliderTableViewCell.identifier)
        
        movieHostTableView.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        
        movieHostTableView.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        
        movieHostTableView.registerForCell(identifier: GenreTableViewCell.identifier)
        
        movieHostTableView.registerForCell(identifier: ShowTimeTableViewCell.identifier)
        
        movieHostTableView.registerForCell(identifier: BestActorsTableViewCell.identifier)
    }
    
    private func handleRefreshControl(){
        movieHostTableView.addSubview(refreshControl)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(_ sender : Any){
        callNetwork()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
       
    
        
    }
    
    //MARK:- Network
    private func callNetwork(){
        //Fetch Upcomming MovieList
        fetchUpCommingMovieList()
        //Fetch Popular MovieList
        fetchPopularMovieList()
        //Fetch Popular SerireList
        fetchPopularSerieList()
        //Fetch Genre List
        fetchGenreList()
        //Fetch TopRatedMovieList for ShowCases
        fetchTopRatedMovieList()
        //Fetch ActorsList
        fetchActorsList()
    }
    
    fileprivate func fetchActorsList(){
        actorModel.getActorsList(page: 1){ (result) in
            
            switch result{
            case .success(let data):
                self.actorList = data
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_BESTACTOR.rawValue), with: .fade)
            case .failure(let error):
                print(error)
            }
            
            
            
        }
    }
    
    fileprivate func fetchTopRatedMovieList(){
        movieModel.getTopRatedMovieList(page: 1){ (result) in
            switch result{
            case .success(let data):
                self.topRatedMovieList = data
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_SHOWCASE.rawValue), with: .fade)
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
    
    fileprivate func fetchGenreList(){
        movieModel.getGenreList{ (result) in
            switch result{
            case .success(let data):
                self.genreList = data
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_GNRE.rawValue), with: .fade)
                
            case .failure(let error):
                print(error)
            }
            
        }
        
       
        
    }
    
    fileprivate func fetchPopularMovieList(){
        movieModel.getPopularMovieList(page: 1){ (result) in
            
            switch result{
            case .success(let data):
                self.popularMovieList = data
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .fade)
                self.popularMovieListResponse = data
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
    
    fileprivate func fetchPopularSerieList(){
        movieModel.getPopularSerieList(page: 1) { (result) in
            
            switch result{
            case .success(let data) :
                self.popularSeriesList = data
                
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.SERIE_POPULAR.rawValue), with: .fade)
                self.popularSeriesListResponse = data
            case .failure(let error) : print(error)
            }
            
            
        }
    }
    
    fileprivate func fetchUpCommingMovieList(){
        movieModel.getUpcommingMovieList(page: 1) { (result) in
            
            switch result{
            case .success(let data) :
                self.upCommingMovieList = data
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue), with: .fade)
            case .failure(let error) : debugPrint(error)
            }
            
        }
        
    }
    
    
    func onTapMovie(id : Int, isSeries : Bool) {
        navigateToMovieDetailsViewController(movieID: id, isSeries: isSeries)
    }
    
    
    
    
}


//MARK:- Extension
extension ViewController : UITableViewDataSource{
    fileprivate func initForMoreMovie(label : UILabel, movieOrSeries : MovieOrSeries){
        
        switch(movieOrSeries){
        case .movie :
            //Register Gesture
            let gestureForlblMoreMovies = UITapGestureRecognizer(target:self, action: #selector(onTapMoreMoives))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(gestureForlblMoreMovies)
        case .series:
            let gestureForlblMoreMovies = UITapGestureRecognizer(target:self, action: #selector(onTapMoreSeries))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(gestureForlblMoreMovies)
        }
        
        
    }
    
    @objc func onTapMoreMoives(){
                navigateToMoreMoviesAndSeriesViewController(movieType: .movie, popularMovieList)
    }
    @objc func onTapMoreSeries(){
                navigateToMoreMoviesAndSeriesViewController(movieType: .series, popularSeriesList)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case MovieType.MOVIE_SLIDER.rawValue:
            let cell = tableView.dequeueTableViewCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
            
            cell.data = upCommingMovieList
            cell.delegate = self
            return cell
            
        case MovieType.MOVIE_POPULAR.rawValue:
            let cell = tableView.dequeueTableViewCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.lblTitle.text = "Popular Movie".uppercased()
            cell.delegate = self
            
            initForMoreMovie(label: cell.lblMoreMovies, movieOrSeries: .movie)
            cell.data = popularMovieList
            
            return cell
            
        case MovieType.SERIE_POPULAR.rawValue:
            let cell = tableView.dequeueTableViewCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.lblTitle.text  = "Popular Series".uppercased()
            cell.delegate = self
            cell.data = popularSeriesList
            initForMoreMovie(label: cell.lblMoreMovies, movieOrSeries: .series)
            
            return cell
            
            
            
        case MovieType.MOVIE_SHOWTIME.rawValue:
            return tableView.dequeueTableViewCell(identifier: ShowTimeTableViewCell.identifier, indexPath: indexPath)
            
            
        case MovieType.MOVIE_GNRE.rawValue:
            let cell =  tableView.dequeueTableViewCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
            cell.delegate = self
            
            
            
            //Init allMovieAndSeries in cell
            var movieList = [MovieResult]()
            movieList.append(contentsOf: upCommingMovieList )
            movieList.append(contentsOf: popularMovieList )
            movieList.append(contentsOf: popularSeriesList )
            cell.allMovieAndSeries = movieList
            //init for genreList
            let genreVOList = genreList.map({ movieGenre -> GenreVO in
                return movieGenre.convertToVOGenre()
            })
            cell.genreList = genreVOList
            //ViewController Level ka nay bae data ga sar ya tl
            genreVOList.first?.isSelected = true
            return cell
            
            
        case MovieType.MOVIE_SHOWCASE.rawValue:
            let cell =  tableView.dequeueTableViewCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
            cell.delegate = self
            cell.showMoreCasesDelegate = self
            cell.data = topRatedMovieList
            // movieListResponse = topRatedMovieList
            return cell
            
            
        case MovieType.MOVIE_BESTACTOR.rawValue:
            let cell =  tableView.dequeueTableViewCell(identifier: BestActorsTableViewCell.identifier, indexPath: indexPath) as
                BestActorsTableViewCell
            cell.delegate = self
            cell.moreActorsDelegate = self
            cell.data = actorList
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
    
    
}


/* URLSession Agent*/
//        movieModelWithURLSession.getGenreList { result in
//            switch result{
//            case .success(let data):
//                self.genreList = data
//                DispatchQueue.main.async {
//                    self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_GNRE.rawValue), with: .fade)
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
