//
//  GenreController.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 2/4/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GenreController {
    
    static func loadGenres(_ manager: SessionManager, url: String ,completition: @escaping (_:[Genre]) -> ()) {
        
        manager.request("\(url)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                
                let json = JSON(value)
                
                let genres = json["genres"]
                var genreList = [Genre]()
                
                for (_, subJSON):(String, JSON) in genres {
                    if let genreId = subJSON["id"].int {
                        if let genreString = subJSON["name"].string {
                            genreList.append(Genre(id: genreId, name: genreString))
                        }
                    }
                }
                
                completition(genreList)
            }
        }
    }
}
