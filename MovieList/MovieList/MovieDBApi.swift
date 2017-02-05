//
//  MovieDBApi.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 2/3/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation
import Alamofire

final class MovieDBApi {
    
    private final let baseUrl = "https://api.themoviedb.org/3/"

    private enum EndPoint: String {
        case configuration = "configuration"
        case genresList = "genre/movie/list"
        case upComingMovies = "movie/upcoming"
        case movieDetail = "movie/"
        case movieCredits = "movie/$/credits"
    }
    
    private let appendToResponse = "&append_to_response="
    
    // videos and images also supports appendo_to_response
    private let appendParms = ["credits"] //["credits", "videos", "images"]
    
    private var apiKeyTag: String
    private var apiKeyValue: String {
        didSet {
            apiKeyTag = "?api_key=\(apiKeyValue)"
        }
    }
    
    private var languageTag: String
    private var languageValue: String {
        didSet {
            languageTag = "&language=\(languageValue)"
        }
    }
    
    private var pageTag: String
    private var pageCount: Int {
        didSet {
            pageTag = "&page=\(pageCount)"
        }
    }
    
    private var totalPages: Int?
    
    private let manager: SessionManager
    private var configuration: Configuration?
    private var movies: [Movie]?
    private var genres: [Genre]?
    
    static let sharedInstance: MovieDBApi = {
        let instance = MovieDBApi()
        
        return instance
    }()
    
    private init() {
        
        let urlConfig = URLSessionConfiguration.default
        urlConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        manager = Alamofire.SessionManager(configuration: urlConfig)
        
        pageCount = 1
        apiKeyValue = "094bda1680d9981474a3647d78d554bd"
        languageValue = "en-US"
        
        apiKeyTag = "?api_key=\(self.apiKeyValue)"
        pageTag = "&page=\(self.pageCount)"
        languageTag = "&language=\(self.languageValue)"
        
        if let langDesignator = NSLocale.preferredLanguages.first{
            languageValue = "\(langDesignator)"
        }
        
        configuration = nil
        movies = nil
        genres = nil
    }
    
    private func loadConfiguration(completition: @escaping () -> ()) {
        
        let configUrl = "\(baseUrl)\(EndPoint.configuration.rawValue)\(apiKeyTag)"
        
        ConfigurationController.loadConfiguration(manager, url: configUrl) { configs in
            
            self.configuration = configs
            completition()
        }
    }
    
    private func loadGenres(completition: @escaping () -> ()) {
        
        let genresUrl = "\(baseUrl)\(EndPoint.genresList.rawValue)\(apiKeyTag)\(languageTag)"
        
        GenreController.loadGenres(manager, url: genresUrl) { genres in
            
            self.genres = genres
            completition()
        }
    }
    
    private func loadMovieList(completition: @escaping () -> ()) {
        
        let moviesUrl = "\(baseUrl)\(EndPoint.upComingMovies.rawValue)\(apiKeyTag)\(languageTag)\(pageTag)"
        
        MovieController.loadMovies(manager, url: moviesUrl) { movieList, totalPages in
            
            self.movies = movieList
            self.totalPages = totalPages
            completition()
            
        }
    }
    
    func loadMovies(completition: @escaping () -> ()) {
        
        if configuration == nil {
            self.loadConfiguration {
                if self.genres == nil {
                    self.loadGenres {
                        self.loadMovieList {
                            completition()
                        }
                    }
                } else {
                    self.loadMovieList {
                        completition()
                    }
                }
            }
        } else {
            self.loadMovieList {
                completition()
            }
        }
    }
}
