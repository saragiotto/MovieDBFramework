//
//  Genre.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 2/4/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation

class Genre {
    let genreId: Int
    let genreName: String
    
    init(id: Int, name: String) {
        self.genreId = id
        self.genreName = name
    }
    
    static func genreName(id: Int, genres: [Genre]) -> String? {
        
        for genre in genres {
            if genre.genreId == id {
                return genre.genreName
            }
        }
        
        return nil
    }
}
