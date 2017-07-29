//
//  Configuration.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 2/4/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation

class Configuration {
    
    let imageBaseUrl: String
    let secureImageBaseUrl: String
    let backdropSize: String
    let posterSize: String
    
    init(imgUrl: String?, secImgUrl: String?, bdSize: String?, pSize: String?) {
        
        if let img = imgUrl {
            imageBaseUrl = img
        } else {
            imageBaseUrl = ""
        }
        
        if let secImg = secImgUrl {
            secureImageBaseUrl = secImg
        } else {
            secureImageBaseUrl = ""
        }
        
        if let bd = bdSize {
            backdropSize = bd
        } else {
            backdropSize = ""
        }
        
        if let p = pSize {
            posterSize = p
        } else {
            posterSize = ""
        }
    }
}
