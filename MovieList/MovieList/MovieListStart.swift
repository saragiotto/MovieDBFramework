//
//  MovieListStart.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 1/21/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieListStart {
    
    private final let baseUrl = "https://api.themoviedb.org/3/"
    private final let apiKeyValue = "1f54bd990f1cdfb230adb312546d765d"
    private final let languageValue = "en-US"
    
    private enum EndPoint: String {
        case configuration = "configuration"
        case genresList = "genre/movie/list"
        case upComingMovies = "movie/upcoming"
        case movieDetail = "movie/"
        case movieCredits = "movie/$/credits"
    }
    
    private let apiKey: String
    private let language: String
    
    private var page: String
    private var pageCount: Int
    
    private(set) var movieList: [Movie]
    private(set) var image_base_url: String?
    private(set) var secure_image_base_url: String?
    
    private(set) var backdrop_sizes: [String]?
    private(set) var preferedBackdropSize: String?
    private(set) var poster_sizes: [String]?
    private(set) var preferedPosterSize: String?
    
    private(set) var genres: [Int: String]?
    private(set) var totalPages: Int?
    
    init() {
        
        pageCount = 1
        apiKey = "?api_key=\(self.apiKeyValue)"
        language = "&language=\(self.languageValue)"
        page = "&page=\(self.pageCount)"
        
        movieList = [Movie]()
        
    }
    
    public func loadApp(completition: @escaping () -> ()) {
        self.loadConfiguration() {
            self.loadGenres() {
                self.loadMovieList() {
                    completition()
                }
            }
        }
    }
    
    public func loadNextPage(completition: @escaping () -> ()) {
        if let totalPages = self.totalPages {
            if self.pageCount < totalPages {
                self.pageCount += 1
                self.page = "&page=\(self.pageCount)"
                self.loadMovieList() {
                    completition()
                }
            } else {
                completition()
            }
        } else {
            completition()
        }
    }
    
    private func loadConfiguration(completition: @escaping () -> Void) {
        
        Alamofire.request("\(baseUrl)\(EndPoint.configuration.rawValue)\(apiKey)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                self.image_base_url = json["images"]["base_url"].string!
                self.secure_image_base_url = json["images"]["secure_base_url"].string!
                
                self.backdrop_sizes = json["images"]["backdrop_sizes"].arrayValue.map({$0.stringValue})
                self.poster_sizes = json["images"]["poster_sizes"].arrayValue.map({$0.stringValue})
                
                switch UIScreen.main.scale {
                case 1.0:
                    self.preferedPosterSize = self.poster_sizes![self.poster_sizes!.count - 4]
                    self.preferedBackdropSize = self.backdrop_sizes![self.backdrop_sizes!.count - 4]
                case 2.0:
                    self.preferedPosterSize = self.poster_sizes![self.poster_sizes!.count - 3]
                    self.preferedBackdropSize = self.backdrop_sizes![self.backdrop_sizes!.count - 3]
                case 3.0:
                    self.preferedPosterSize = self.poster_sizes![self.poster_sizes!.count - 2]
                    self.preferedBackdropSize = self.backdrop_sizes![self.backdrop_sizes!.count - 2]
                default:
                    self.preferedPosterSize = self.poster_sizes!.first
                    self.preferedBackdropSize = self.backdrop_sizes!.first
                }
                
                print("Prefered sizes \(self.preferedPosterSize) \(self.preferedBackdropSize)")
                
                completition()
            }
        }
    }
    
    private func loadGenres(completition: @escaping () -> Void) {
        
        self.genres = [Int: String]()
        
        Alamofire.request("\(baseUrl)\(EndPoint.genresList.rawValue)\(apiKey)\(language)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                
                let json = JSON(value)
                
                let genres = json["genres"]
                
                for (_, subJSON):(String, JSON) in genres {
                    let genreId = subJSON["id"].int!
                    let genreString = subJSON["name"].string!
                    
                    self.genres![genreId] = genreString
                }
                
                completition()
            }
        }
    }
    
    private func loadMovieList(completition: @escaping () -> Void) {
        Alamofire.request("\(baseUrl)\(EndPoint.upComingMovies.rawValue)\(apiKey)\(language)\(page)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                self.totalPages = json["total_pages"].int
                
                self.movieList += json["results"].arrayValue.map({ Movie(json: $0) })
                
                completition()
            }
        }
    }
    
    public func loadMovieDetail(movie: Movie, completition: @escaping () -> Void) {
        Alamofire.request("\(baseUrl)\(EndPoint.movieDetail.rawValue)\(movie.id)\(apiKey)\(language)").responseJSON { response in
            debugPrint(response)
        
            if let value = response.result.value {
                let json = JSON(value)
                
                let homepage = json["homepage"].string
                
                if !homepage!.isEmpty {
                    movie.homepage = homepage
                }
                
                completition()
            }
        }
    }
    
    public func loadMovieCast(movie: Movie, completition: @escaping () -> Void) {
        
        var movieEndPointWithId = "\(EndPoint.movieCredits.rawValue)"
        movieEndPointWithId.replaceSubrange(movieEndPointWithId.range(of: "$")!, with: "\(movie.id)")
        
        Alamofire.request("\(baseUrl)\(movieEndPointWithId)\(apiKey)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                let castInfo =  json["cast"].arrayValue.map({$0["name"].stringValue})
                
                if !castInfo.isEmpty {
                    if castInfo.count < 6 {
                        movie.cast = castInfo
                    } else {
                        movie.cast = Array(castInfo[0..<5])
                    }
                }
                
                completition()
            }
        }
    }
}
