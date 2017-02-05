//
//  MovieDetailViewController.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 1/22/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import UIKit
import ChameleonFramework

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backdropMovie: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overviewInfo: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var cast: UILabel!
    
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var populatiry: UILabel!
    @IBOutlet weak var website: UILabel!
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    var movieIndex: Int?
    
    private var movie = Movie()
    
    private var curtainsView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        movie = MovieDBApi.sharedInstance.movies![movieIndex!]
        
        website.text = " "
        cast.text = " "
        runTime.text = ""
        
        if !movie.detailedMovie {
            print("request movie detail!")
            requestMovieDetails()
        } else {
            putMovieDetailOnScreen()
        }
        
        if let title = movie.title {
            movieTitle.text = title
        } else {
            if let originalTitle = movie.originalTitle {
                movieTitle.text = originalTitle
            } else {
                movieTitle.text = "Title Not Available"
            }
        }
        
        self.navigationItem.title = movieTitle.text!
        
        if let overview = movie.overview {
            overviewInfo.text = overview
        } else {
            overviewInfo.text = "Overview not available."
        }
        
        if let movieDate = movie.releaseDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let releaseDateFormatted = dateFormatter.date(from: movieDate)
            
            let newDateFormat = DateFormatter()
            newDateFormat.dateStyle = .medium
            
            releaseDate.text = newDateFormat.string(from: releaseDateFormatted!)
        } else {
            releaseDate.text = "To be announced"
        }

        var genreArray = [String]()
        
        for genreId in movie.genres_ids {
            if let name = Genre.genreName(id: genreId, genres: MovieDBApi.sharedInstance.genres!) {
                genreArray.append(name)
            }
        }
        
        if !genreArray.isEmpty {
            genre.text = genreArray.joined(separator: ", ")
        } else {
            genre.text = "-"
        }
        
        if let popMovie = movie.voteAverage, popMovie > 0.0 {
            populatiry.textColor = UIColor.flatYellowColorDark()
            populatiry.text = String(format:"%.1f", popMovie)
        } else {
            populatiry.text = ""
        }
        
        if let backDropimg = movie.backdropImage {
            backdropMovie.image = backDropimg
        } else {
            if let backdropPath = movie.backdropPath {
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let movieId = self.movie.id
                    
                    let configs = MovieDBApi.sharedInstance.configuration!
                    
                    let urlString = "\(configs.secureImageBaseUrl)\(configs.backdropSize)\(backdropPath)"
                    
                    if let url = NSURL(string:urlString) {
                        
                        if let imgData = NSData(contentsOf: url as URL) {
                            if let img = UIImage(data: imgData as Data) {
                                
                                DispatchQueue.main.async {
                                    
                                    if movieId == self.movie.id {
                                        self.movie.backdropImage = img
                                        self.backdropMovie.image = img
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                backdropMovie.image = UIImage(named: "NoPosterNew.png")!
            }
        }
        
        let deviceWidth = UIScreen.main.bounds.size.width
        
        let scrollViewHeight = backdropMovie.frame.size.height + overviewInfo.frame.size.height + infoView.frame.size.height
        
        print("Scroll view content size \(deviceWidth) \(scrollViewHeight)")
        
        self.detailScrollView.contentSize = CGSize(width: deviceWidth, height: scrollViewHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        MovieDBApi.sharedInstance.memoryWarning(visibleMovieIds: nil, detailedMovieId: self.movie.id)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    public func openWebsite() {
        if let website = self.movie.homepage {
            UIApplication.shared.open(URL.init(string: website)!, options: [:], completionHandler: nil)
        }
        
        return
    }

    private func requestMovieDetails() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        curtainsView.frame = self.view.frame
        curtainsView.backgroundColor = UIColor.black
        curtainsView.alpha = 1.0
        
        self.view.addSubview(curtainsView)
        
        MovieDBApi.sharedInstance.loadMovieDetail(movie) { movie in
            
            self.putMovieDetailOnScreen()
            
            self.curtainsView.removeFromSuperview()
        }
    }
    
    private func putMovieDetailOnScreen() {

        if let homepage = self.movie.homepage {
            
            let url = URL(string: homepage)
            
            self.website.textColor = UIColor.flatYellowColorDark()
            self.website.text = url!.host!
            self.website.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(MovieDetailViewController.openWebsite)))
            
        } else {
            self.website.text = "Not available"
        }
        
        if let movieCast = self.movie.cast {
            self.cast.text = movieCast.joined(separator: ", ")
        }
        
        if let movieRunTime = self.movie.finalRunTime {
            self.runTime.text = "\(movieRunTime)"
        } else {
            self.runTime.text = "-"
        }
    }
}
