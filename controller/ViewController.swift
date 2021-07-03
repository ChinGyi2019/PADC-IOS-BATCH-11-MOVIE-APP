//
//  ViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 24/01/2021.
//

import UIKit

class ViewController: UIViewController , MovieItemDelegate{
   
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var ivLineWeight: UIImageView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var movieHostTableView: UITableView!
    
    @IBOutlet weak var toolbarView: UIView!
    private var upCommingMovieList : MovieListResponse?
    private var popularMovieList : MovieListResponse?
    private var popularSeriesList : MovieListResponse?
    private var topRatedMovieList : MovieListResponse?
    private var actorList : ActorListResponse?
    private var genreList : MovieGenreList?
    
    
    
    let netwrokingAgent = MovieDBNetwrokingAgent.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        movieHostTableView.dataSource = self
       // movieHostTableView.rowHeight = 240
        
        
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
    
    fileprivate func fetchActorsList(){
        netwrokingAgent.getActorsList{ (data) in
            self.actorList = data
            self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_BESTACTOR.rawValue), with: .fade)
        } failure: { (error) in
            debugPrint(error)
        }
    }
    
    fileprivate func fetchTopRatedMovieList(){
        netwrokingAgent.getTopRatedMovieList{ (data) in
            self.topRatedMovieList = data
            self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_SHOWCASE.rawValue), with: .fade)
        } failure: { (error) in
            debugPrint(error)
        }
    }
    
    fileprivate func fetchGenreList(){
        netwrokingAgent.getGenreList{ (data) in
            self.genreList = data
            self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_GNRE.rawValue), with: .fade)
        } failure: { (error) in
            debugPrint(error)
        }
    }
    fileprivate func fetchPopularMovieList(){
        netwrokingAgent.getPopularMovieList{ (data) in
            self.popularMovieList = data
            self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .fade)
        } failure: { (error) in
            debugPrint(error)
        }
    }
    
    fileprivate func fetchPopularSerieList(){
        netwrokingAgent.getPopularSerieList { (data) in
            self.popularSeriesList = data
            self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.SERIE_POPULAR.rawValue), with: .fade)
        } failure: { (error) in
            debugPrint(error)
        }
    }
    
     fileprivate func fetchUpCommingMovieList(){
        netwrokingAgent.getUpcommingMovieList { (data) in
            self.upCommingMovieList = data
            self.movieHostTableView.reloadSections(IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue), with: .fade)
        } failure: { (error) in
            debugPrint(error)
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
            cell.data = popularMovieList
            
           return cell
            
        case MovieType.SERIE_POPULAR.rawValue:
            let cell = tableView.dequeueTableViewCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.lblTitle.text  = "Popular Series".uppercased()
            cell.delegate = self
            cell.data = popularSeriesList
            
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
            cell.data = topRatedMovieList
            return cell
           
         
        case MovieType.MOVIE_BESTACTOR.rawValue:
            let cell =  tableView.dequeueTableViewCell(identifier: BestActorsTableViewCell.identifier, indexPath: indexPath) as BestActorsTableViewCell
            cell.data = actorList
            
        return cell
        default:
            return UITableViewCell()
        }
       
    }
    
    
    
    
}

