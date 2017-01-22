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
    
    private(set) var id = 0
    
    private(set) var posterPath: String?
    private(set) var overview: String?
    private(set) var title: String?
    private(set) var originalTitle: String?
    private(set) var backdropPath: String?
    private(set) var releaseDate: String?
    private(set) var originalLanguage: String?
    private(set) var voteCount: Int?
    private(set) var voteAverage: Int?
    private(set) var popularity: Double?
    private(set) var video: Bool?
    
    private(set) var genres_ids = [Int]()
    
    internal var posterImage: UIImage?
    internal var backdropImage: UIImage?
    
    init() {
        posterImage = nil
        backdropImage = nil
    }
    
    init(json: JSON) {
        
        self.posterPath = json["poster_path"].string
        self.overview = json["overview"].string
        self.title = json["title"].string
        self.originalTitle = json["original_title"].string
        
        self.backdropPath = json["backdrop_path"].string
        
        self.releaseDate = json["release_date"].string
        self.id = json["id"].int!
        
        self.genres_ids =  json["genre_ids"].arrayValue.map({$0.intValue})
        
        self.originalLanguage = json["original_language"].string
        self.voteCount = json["vote_count"].int
        self.voteAverage = json["vote_average"].int
        self.popularity = json["popularity"].double
        self.video = json["video"].bool
        
        posterImage = nil
        backdropImage = nil
    }
}
