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
    private(set) var voteAverage: Double?
    private(set) var popularity: Double?
    private(set) var video: Bool?
    private(set) var finalRunTime: String?
    private(set) var genres_ids = [Int]()
    
    internal var posterImage: UIImage?
    internal var backdropImage: UIImage?
    internal var homepage: String?
    internal var cast: [String]?
    internal var runTime: Int? {
        didSet {
            if let rt  = runTime, rt > 0 {
                if rt < 60 {
                    finalRunTime = "\(rt)m"
                } else {
                    let hours = rt/60
                    let minutes = rt%60
                    finalRunTime = "\(hours)h \(minutes)m"
                }
            }
        }
    }
    
    internal var detailedMovie = false
    
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
        self.voteAverage = json["vote_average"].double
        self.popularity = json["popularity"].double
        self.video = json["video"].bool
        
        posterImage = nil
        backdropImage = nil
    }
}
