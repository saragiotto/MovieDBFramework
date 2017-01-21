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
    
    private var poster_path = ""
    
    private var overview = ""
    
    private var title = ""
    
    private var original_title = ""
    
    private var backdrop_path = ""
    
    private var release_date = ""
    
    private var id = 0
    
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
