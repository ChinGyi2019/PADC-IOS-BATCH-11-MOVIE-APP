//
//  ViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 24/01/2021.
//

import UIKit

class ViewController: UIViewController , MovieItemDelegate, ActorItemDelegate, ShowMoreActorsDelegate, ShowMoreShowCasesDelegate{
   
    
    func didTabMoreShowCases() {
        navigateToShowMoreShowCasesViewController(movieResponse: movieListResponse)
    }
    
    func didTabMoreActors() {
        navigateToShowMoreActorsViewController(actorResponse: actorListResponse)
    }
    
    func didTabActor(id: Int) {
        print(id)
        navigateToActorDetailsViewController(id: id)
    }
    
   
    
//    @IBOutlet weak var labelTitle: UILabel!
//    @IBOutlet weak var ivLineWeight: UIImageView!
//    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var movieHostTableView: UITableView!
//    @IBOutlet weak var toolbarView: UIView!
    
    private var upCommingMovieList : MovieListResponse?
    private var popularMovieList : MovieListResponse?
    private var popularSeriesList : MovieListResponse?
    private var topRatedMovieList : MovieListResponse?
    private var actorList : ActorListResponse?
    private var genreList : MovieGenreList?
    private var actorListResponse : ActorListResponse? = nil
    private var movieListResponse : MovieListResponse? = nil
    private var popularMovieListResponse : MovieListResponse? = nil
    private var popularSeriesListResponse : MovieListResponse? = nil
    
    
    private let netwrokingAgent = MovieDBNetwrokingAgent.shared
    private let netwrokingAgentWithURLSession = NetworkAgentWithURLSession.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        movieHostTableView.dataSource = self
        if #available(iOS 14.0, *) {
            navigationItem.backBarButtonItem = UIBarButtonItem(title : "")
        } else {
            // Fallback on earlier versions
        }
        
        
        //Registering
        registerTableViewCell()
        
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
    

    @IBAction func onTapSearchImageIcon(_ sender : Any){
        navigateToSearchMovieViewController()
    }
    
    
    fileprivate func fetchActorsList(){
        netwrokingAgent.getActorsList{ (result) in
            
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
        netwrokingAgent.getTopRatedMovieList{ (result) in
            
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
        netwrokingAgent.getGenreList{ (result) in
            switch result{
            case .success(let data):
                self.genreList = data
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_GNRE.rawValue), with: .fade)
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        /* URLSession Agent*/
//        netwrokingAgentWithURLSession.getGenreList { result in
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
        
    }
    
    fileprivate func fetchPopularMovieList(){
        netwrokingAgent.getPopularMovieList{ (result) in
            
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
        netwrokingAgent.getPopularSerieList { (result) in
            
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
        netwrokingAgent.getUpcommingMovieList { (result) in
            
            switch result{
            case .success(let data) :
                self.upCommingMovieList = data
                self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue), with: .fade)
            case .failure(let error) : debugPrint(error)
            }
            
        }

    }
    
    private func registerTableViewCell(){
        
        movieHostTableView.registerForCell(identifier:MovieSliderTableViewCell.identifier)
        
        movieHostTableView.registerForCell(identifier: PopularFilmTableViewCell.identifier)

        movieHostTableView.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        
        movieHostTableView.registerForCell(identifier: GenreTableViewCell.identifier)
      
        movieHostTableView.registerForCell(identifier: ShowTimeTableViewCell.identifier)
    
        movieHostTableView.registerForCell(identifier: BestActorsTableViewCell.identifier)
    }
    
    func onTapMovie(id : Int, isSeries : Bool) {
       navigateToMovieDetailsViewController(movieID: id, isSeries: isSeries)
    }
    
    


}

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
        navigateToMoreMoviesAndSeriesViewController(movieType: .movie, popularMovieListResponse)
    }
    @objc func onTapMoreSeries(){
        navigateToMoreMoviesAndSeriesViewController(movieType: .series, popularSeriesListResponse)
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
            movieList.append(contentsOf: upCommingMovieList?.results ?? [MovieResult]())
            movieList.append(contentsOf: popularMovieList?.results ?? [MovieResult]())
            movieList.append(contentsOf: popularSeriesList?.results ?? [MovieResult]())
            cell.allMovieAndSeries = movieList
            //init for genreList
            let genreVOList = genreList?.genres?.map({ movieGenre -> GenreVO in
                return movieGenre.convertToVOGenre()
            })
            cell.genreList = genreVOList
            //ViewController Level ka nay bae data ga sar ya tl
            genreVOList?.first?.isSelected = true
            return cell
           
            
        case MovieType.MOVIE_SHOWCASE.rawValue:
       let cell =  tableView.dequeueTableViewCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
            cell.delegate = self
            cell.showMoreCasesDelegate = self
            cell.data = topRatedMovieList
            movieListResponse = topRatedMovieList
            return cell
           
         
        case MovieType.MOVIE_BESTACTOR.rawValue:
            let cell =  tableView.dequeueTableViewCell(identifier: BestActorsTableViewCell.identifier, indexPath: indexPath) as
                BestActorsTableViewCell
            cell.delegate = self
            cell.moreActorsDelegate = self
            cell.data = actorList
            actorListResponse = actorList
            
            
        return cell
        default:
            return UITableViewCell()
        }
       
    }
    
    
    
    
}

