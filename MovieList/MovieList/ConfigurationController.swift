//
//  ConfigurationController.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 2/4/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConfigurationController {
    
    static func loadConfiguration(_ manager: SessionManager, url: String ,completition: @escaping (_:Configuration) -> ()) {
        
        manager.request("\(url)").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                let imageBaseUrl = json["images"]["base_url"].string
                let secureImageBaseUrl = json["images"]["secure_base_url"].string
                
                let backdropSizes = json["images"]["backdrop_sizes"].arrayValue.map({$0.stringValue})
                let posterSizes = json["images"]["poster_sizes"].arrayValue.map({$0.stringValue})
                
                let bdSize = self.defineBackdropSize(backdropSizes)
                let pSize = self.definePosterSize(posterSizes)
                
                let configs = Configuration(imgUrl: imageBaseUrl, secImgUrl: secureImageBaseUrl, bdSize: bdSize, pSize: pSize)
                completition(configs)
            }
        }
    }
    
    static private func definePosterSize(_ posterSizes: [String]) -> String {
        
        let deviceWidth = Double(UIScreen.main.bounds.size.width)
        let deviceScaleFactor = Double(UIScreen.main.scale)
        
        let posterViewWidth = (deviceWidth / 2 - 2) * deviceScaleFactor
        
        var maxSize = ""
        var preferredPosterSize = ""
        
        for size in posterSizes {
            
            if let doubleSize = Double(self.sizeString(size)) {
                maxSize = size
                if doubleSize < posterViewWidth {
                    preferredPosterSize = size
                } else {
                    break
                }
            }
        }
        
        if (preferredPosterSize.isEmpty) {
            if !maxSize.isEmpty {
                preferredPosterSize = maxSize
            } else {
                preferredPosterSize = posterSizes.last!
            }
        }
        
        print("preferredPosterSize: \(preferredPosterSize)")
        
        return preferredPosterSize
    }
    
    static private func defineBackdropSize(_ backdropSizes: [String]) -> String {
        
        let deviceWidth = Double(UIScreen.main.bounds.size.width)
        let deviceScaleFactor = Double(UIScreen.main.scale)
        let backdropViewWidth = deviceWidth * deviceScaleFactor
        
        var maxSize = ""
        var preferredBackdropSize = ""
        
        for size in backdropSizes {
            
            if let doubleSize = Double(self.sizeString(size)) {
                maxSize = size
                if doubleSize < backdropViewWidth {
                    preferredBackdropSize = size
                } else {
                    break
                }
            }
        }
        
        if (preferredBackdropSize.isEmpty) {
            if !maxSize.isEmpty {
                preferredBackdropSize = maxSize
            } else {
                preferredBackdropSize = backdropSizes.last!
            }
        }
        
        return preferredBackdropSize
    }
    
    static private func sizeString(_ widthSize: String) -> String {
        
        let numericSet = "0123456789"
        let filteredCharacters = widthSize.characters.filter {
            return numericSet.contains(String($0))
        }
        
        return String(filteredCharacters)
    }
}
