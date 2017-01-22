//
//  Movie.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 1/21/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    
    var poster_path = ""
    
    var overview = ""
    
    var title: String?
    
    var original_title: String?
    
    var backdrop_path: String?
    
    var release_date: String?
    
    var id = 0
    
    var posterImage: UIImage?
    
    var genres_ids = [Int]()
    
    init() {
        posterImage = nil
    }
    
    init(json: JSON) {
        self.poster_path = json["poster_path"].string!
        
        self.overview = json["overview"].string!
        
        self.title = json["title"].string
        
        self.original_title = json["original_title"].string
        
        self.backdrop_path = json["backdrop_path"].string
        
        self.release_date = json["release_date"].string
        
        self.id = json["id"].int!
        
        self.genres_ids =  json["genre_ids"].arrayValue.map({$0.intValue})
        
        posterImage = nil
        
    }
    
}
