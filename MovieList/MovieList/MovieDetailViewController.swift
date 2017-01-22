//
//  MovieDetailViewController.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 1/22/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backdropMovie: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overviewInfo: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genre: UILabel!
    
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var populatiry: UILabel!
    @IBOutlet weak var website: UILabel!
    
    var movieIndex: Int?
    var movieApp: MovieListStart?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let movie = self.movieApp!.movieList[movieIndex!]
        
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
            genreArray.append(self.movieApp!.genres![genreId]!)
        }
        
        if !genreArray.isEmpty {
            genre.text = genreArray.joined(separator: ", ")
        } else {
            genre.text = "-"
        }
        
        if let popMovie = movie.popularity {
            populatiry.text = String(format:"%.1f", popMovie)
        } else {
            populatiry.text = ""
        }
        
        if let backDropimg = movie.backdropImage {
            backdropMovie.image = backDropimg
        } else {
            if let backdropPath = movie.backdropPath {
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let movieId = movie.id
                    
                    if let url = NSURL(string:"\(self.movieApp!.secure_image_base_url!)\(self.movieApp!.preferedBackdropSize!)\(backdropPath)") {
                        
                        if let imgData = NSData(contentsOf: url as URL) {
                            
                            print("backdrop download complete!")
                            
                            if let img = UIImage(data: imgData as Data) {
                                
                                DispatchQueue.main.async {
                                    
                                    if movieId == movie.id {
                                        
                                        print("backdrop should appear now!")
                                        
                                        self.movieApp!.movieList[self.movieIndex!].backdropImage = img
                                        self.backdropMovie.image = img
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
