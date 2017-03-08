//
//  MovieController.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 2/4/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieController {
    
    static func loadMovies(_ manager: SessionManager, url: String, completition: @escaping (_:[Movie],_:Int?) -> ()) {
    
        print("Alamofire [Request]")
        manager.request("\(url)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                var movieList = [Movie]()
                
                let totalPages = json["total_pages"].int
                
                movieList += json["results"].arrayValue.map({ Movie(json: $0) })
                
                completition(movieList, totalPages)
            }
        }
    
    }
    
    static func loadMovieDetail(_ manager: SessionManager, url: String, movie: Movie, completition: @escaping (_:Movie) -> ()) {
        
        manager.request(url).responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                movie.detailedMovie = true
                
                if let homepage = json["homepage"].string {
                    if !homepage.isEmpty {
                        movie.homepage = homepage
                    }
                }
                
                
                if let runTime = json["runtime"].int {
                    movie.runTime = runTime
                }
                
                
                if let credits = json["credits"].dictionary {
                    let castInfo =  credits["cast"]?.arrayValue.map({$0["name"].stringValue})
                    
                    if !castInfo!.isEmpty {
                        if castInfo!.count < 6 {
                            movie.cast = castInfo
                        } else {
                            movie.cast = Array(castInfo![0..<5])
                        }
                    }
                }
                
                completition(movie)
            }
        }
    }
    
    static func memoryWarning(movies:[Movie], _ visibleMovieIds: [Int]?, _ detailedMovieId: Int?) {
        
        if visibleMovieIds != nil {
            
            for movie in movies {
                movie.backdropImage = nil
                
                if  !visibleMovieIds!.contains(movie.id) {
                    movie.posterImage = nil
                }
            }
        }
        
        if detailedMovieId != nil {
            
            for movie in movies {
                
                if movie.id != detailedMovieId! {
                    movie.backdropImage = nil
                }
            }
        }
    }
    
    static func posterImage(_ movie: Movie, url: String, completition: @escaping (_:UIImage?) -> ()) {
        
//        let movieId = movie.id
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let url = NSURL(string:url) {
                
                if let imgData = NSData(contentsOf: url as URL) {
                    
                    if let img = UIImage(data: imgData as Data) {
                        
                        movie.posterImage = img
                        
                        DispatchQueue.main.async {
                            
//                            if movieId == movie.id {

                                completition(img)

//                            }
                        }
                    }
                }
            }
        }
    }
    
    static func backdropImage(_ movie: Movie, url: String, completition: @escaping (_:UIImage?) -> ()) {
        
        let movieId = movie.id
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let url = NSURL(string:url) {
                
                if let imgData = NSData(contentsOf: url as URL) {
                    
                    if let img = UIImage(data: imgData as Data) {
                        
                        DispatchQueue.main.async {
                            
                            if movieId == movie.id {
                                
                                movie.backdropImage = img
                                completition(img)
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
