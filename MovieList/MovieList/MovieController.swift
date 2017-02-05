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
}
