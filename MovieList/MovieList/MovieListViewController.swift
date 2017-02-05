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
import ChameleonFramework

private let reuseIdentifier = "MovieListViewCell"

class MovieListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    var image_base_url = ""
//    var secure_image_base_url = ""
//    var backdrop_sizes = [String]()
//    var poster_sizes = [String]()
//    var genres = [Int: String]()
    
    private var movieApp = MovieListStart()
    
//    var movieList = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: nil, action: nil)
        
        rightSearchBarButtonItem.tintColor = UIColor.flatYellowColorDark()
        
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)

        UIApplication.shared.statusBarStyle = .lightContent
    
        self.movieApp.loadApp() {
            self.collectionView?.reloadData()
        }
        
//        MovieDBApi.sharedInstance.loadConfiguration {
//            print("config loaded!")
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        if let indexPaths = self.collectionView?.indexPathsForVisibleItems {
        
            var movieIds = [Int]()
            
            for index in indexPaths {
                movieIds.append(self.movieApp.movieList[index.row].id)
            }
            
            self.movieApp.cleanPosterImages(exceptThis: movieIds)
        }
    }
    
    private struct Storyboard {
        static let movieDetailIdentifier = "movieDetail"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
        case Storyboard.movieDetailIdentifier:
            if let movieDetailVC = segue.destination as? MovieDetailViewController {
                movieDetailVC.movieApp = self.movieApp
                movieDetailVC.movieIndex = self.collectionView!.indexPathsForSelectedItems!.first!.row
            }
        default:
            break
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return self.movieApp.movieList.count

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieListViewCell
        
        // Configure the cell
        
        cell.movieApp = self.movieApp
        cell.movieIndex = indexPath.row
        
        if (indexPath.row == self.movieApp.movieList.count - 1) {
            self.movieApp.loadNextPage {
                print("carregou proxima pagina! \(self.movieApp.movieList.count)")
                self.collectionView?.reloadData()
            }
        }

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
        
        let screenWidth = UIScreen.main.bounds.width
        
        let itemWidth = screenWidth/2 - 2
        let itemHeight = (itemWidth/3) * 5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }

}
