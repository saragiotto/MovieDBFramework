//
//  MovieListViewController.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 1/21/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


private let reuseIdentifier = "MovieListViewCell"

class MovieListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var movieList = [Movie]()
    
    var image_base_url = ""
    var secure_image_base_url = ""
    var backdrop_sizes = [String]()
    var poster_sizes = [String]()
    var genres = [Int: String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
        Alamofire.request("https://api.themoviedb.org/3/configuration?api_key=1f54bd990f1cdfb230adb312546d765d").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                let json = JSON(value)
                
                self.image_base_url = json["images"]["base_url"].string!
                self.secure_image_base_url = json["images"]["secure_base_url"].string!
                
                self.backdrop_sizes = json["images"]["backdrop_sizes"].arrayValue.map({$0.stringValue})
                self.poster_sizes = json["images"]["poster_sizes"].arrayValue.map({$0.stringValue})
                
                Alamofire.request("https://api.themoviedb.org/3/movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US").responseJSON { response in
                    debugPrint(response)
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        self.movieList = json["results"].arrayValue.map({ Movie(json: $0) })
                        
                    }
                    
                    self.collectionView!.reloadData()
                }
            }
        }
        
        Alamofire.request("https://api.themoviedb.org/3/genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US").responseJSON { response in
            debugPrint(response)
            
            if let value = response.result.value {
                
                let json = JSON(value)
                
                let genres = json["genres"]
                
                for (_, subJSON):(String, JSON) in genres {
                    let genreId = subJSON["id"].int!
                    let genreString = subJSON["name"].string!
                    
                    self.genres[genreId] = genreString
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.movieList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieListViewCell
        
        // Configure the cell
        
        cell.movie = self.movieList[indexPath.row]
        cell.secure_image_base_url = self.secure_image_base_url

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let itemWidth = screenWidth/2 - 10
        let itemHeight = (itemWidth/4) * 5
        
        return CGSize(width: screenWidth/2 - 10, height: itemHeight)
    }

}
