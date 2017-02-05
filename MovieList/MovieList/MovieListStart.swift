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
    private final let apiKeyValue = "094bda1680d9981474a3647d78d554bd"
    private final let languageValue = "en-US"
    private final let preferredLanguage:String
    
    private enum EndPoint: String {
        case configuration = "configuration"
        case genresList = "genre/movie/list"
        case upComingMovies = "movie/upcoming"
        case movieDetail = "movie/"
        case movieCredits = "movie/$/credits"
    }
    
    private let appendToResponse = "&append_to_response="
    
    //
    // videos and images also supports appendo_to_response
    //
    private let appendParms = ["credits"]
    
    private let apiKey: String
    private let language: String
    
    private var page: String
    private var pageCount: Int
    
    private(set) var movieList: [Movie]
    private(set) var image_base_url: String?
    private(set) var secure_image_base_url: String?
    
    private(set) var backdrop_sizes: [String]?
    private(set) var preferredBackdropSize: String?
    private(set) var poster_sizes: [String]?
    private(set) var preferredPosterSize: String?
    
    private(set) var genres: [Int: String]?
    private(set) var totalPages: Int?
    
    private var manager: SessionManager
    
    init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        manager = Alamofire.SessionManager(configuration: configuration)
        
        let langDesignator = NSLocale.preferredLanguages.first
        
        if let lang = langDesignator {
            preferredLanguage = "\(lang)"
        } else {
            preferredLanguage = self.languageValue
        }
        
        pageCount = 1
        apiKey = "?api_key=\(self.apiKeyValue)"
        language = "&language=\(self.preferredLanguage)"
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
    
    public func cleanPosterImages(exceptThis movieIdsDisplayed: [Int]) {
        
        for movie in self.movieList {
            movie.backdropImage = nil
            
            if  !movieIdsDisplayed.contains(movie.id) {
                movie.posterImage = nil
            }
        }
    }
    
    public func cleanBackDropsImages(exceptThis movieIdDisplayed: Int) {
        
        for movie in self.movieList {
            
            if movie.id != movieIdDisplayed {
                movie.backdropImage = nil
            }
        }
    }
    
    private func loadConfiguration(completition: @escaping () -> Void) {
        
        manager.request("\(baseUrl)\(EndPoint.configuration.rawValue)\(apiKey)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                self.image_base_url = json["images"]["base_url"].string!
                self.secure_image_base_url = json["images"]["secure_base_url"].string!
                
                self.backdrop_sizes = json["images"]["backdrop_sizes"].arrayValue.map({$0.stringValue})
                self.poster_sizes = json["images"]["poster_sizes"].arrayValue.map({$0.stringValue})
                
                self.definepreferredSizes()
                
                completition()
            }
        }
    }
    
    /*
    // focus on the better experience, the app calculates
    // the width of each view that will display images
    // to guarantee that the image file always will be
    // larger than the view it's presented
    //
    // once the view is calculated in points, it's necessary
    // multiply it's value by the devive scale factor
    */
    private func definepreferredSizes() {
        let deviceWidth = Double(UIScreen.main.bounds.size.width)
        let deviceScaleFactor = Double(UIScreen.main.scale)
        
        let posterViewWidth = (deviceWidth / 2 - 2) * deviceScaleFactor
        
        var maxSize = ""
        
        for size in self.poster_sizes! {
            
            if let doubleSize = Double(self.sizeString(size)) {
                maxSize = size
                if doubleSize > posterViewWidth {
                    self.preferredPosterSize = size
                    break
                }
            }
        }
        
        if (self.preferredPosterSize?.isEmpty)! {
            if !maxSize.isEmpty {
                self.preferredPosterSize = maxSize
            } else {
                self.preferredPosterSize = self.poster_sizes?.last
            }
        }
        
        let backdropViewWidth = deviceWidth * deviceScaleFactor
        
        maxSize = ""
        
        for size in self.backdrop_sizes! {
            
            if let doubleSize = Double(self.sizeString(size)) {
                maxSize = size
                if doubleSize > backdropViewWidth {
                    self.preferredBackdropSize = size
                    break
                }
            }
        }
        
        if (self.preferredBackdropSize?.isEmpty)! {
            if !maxSize.isEmpty {
                self.preferredBackdropSize = maxSize
            } else {
                self.preferredBackdropSize = self.backdrop_sizes?.last
            }
        }

        print("Preferred sizes \(self.preferredPosterSize) \(self.preferredBackdropSize) \(deviceWidth) \(deviceScaleFactor)")
    }
    
    private func sizeString(_ widthSize: String) -> String {
        
        let numericSet = "0123456789"
        let filteredCharacters = widthSize.characters.filter {
            return numericSet.contains(String($0))
        }
        
        return String(filteredCharacters)
    }
    
    private func loadGenres(completition: @escaping () -> Void) {
        
        self.genres = [Int: String]()
        
        manager.request("\(baseUrl)\(EndPoint.genresList.rawValue)\(apiKey)\(language)").responseJSON { response in
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
        manager.request("\(baseUrl)\(EndPoint.upComingMovies.rawValue)\(apiKey)\(language)\(page)").responseJSON { response in
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
        
        var endPointUrl = "\(baseUrl)\(EndPoint.movieDetail.rawValue)\(movie.id)\(apiKey)\(language)"
        
        endPointUrl.append("\(appendToResponse)\(appendParms.joined(separator: ","))")
        
        manager.request(endPointUrl).responseJSON { response in
            debugPrint(response)
        
            if let value = response.result.value {
                let json = JSON(value)
                
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
            
                completition()
            }
        }
    }
}
