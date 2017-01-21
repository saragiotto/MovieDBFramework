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
    
    var title = ""
    
    var original_title = ""
    
    var backdrop_path = ""
    
    var release_date = ""
    
    var id = 0
    
    init() {
        
    }
    
    init(json: JSON) {
        self.poster_path = json["poster_path"].string!
        
        self.overview = json["overview"].string!
        
        self.title = json["title"].string!
        
        self.original_title = json["original_title"].string!
        
        self.backdrop_path = json["backdrop_path"].string!
        
        self.release_date = json["release_date"].string!
        
        self.id = json["id"].int!
        
    }
    
}
