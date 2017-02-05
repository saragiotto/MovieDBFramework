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
}
