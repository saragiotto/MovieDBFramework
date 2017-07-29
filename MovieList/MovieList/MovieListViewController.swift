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
    
    private var movieDBModel:MovieDBApi? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
        movieDBModel = MovieDBApi.sharedInstance
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(MovieListViewController.presentAboutScreen))
        
        rightSearchBarButtonItem.tintColor = UIColor.flatYellowColorDark()
        
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MovieDBApi.sharedInstance.loadMovies {
            self.collectionView?.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        MovieDBApi.sharedInstance.performWhenNetworkIsBackAlive {
            self.collectionView?.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        if let indexPaths = self.collectionView?.indexPathsForVisibleItems {
        
            if let movies = movieDBModel!.movies {
            
                var movieIds = [Int]()
                
                for index in indexPaths {
                    movieIds.append(movies[index.row].id)
                }
                
                movieDBModel!.memoryWarning(visibleMovieIds: movieIds, detailedMovieId: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    private struct Storyboard {
        static let movieDetailIdentifier = "movieDetail"
        static let aboutScreenIdentifier = "aboutViewController"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
        case Storyboard.movieDetailIdentifier:
            if let movieDetailVC = segue.destination as? MovieDetailViewController {
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
        
        if let movies = movieDBModel!.movies {
            return movies.count
        } else {
            return 0
        }

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieListViewCell
        
        // Configure the cell

        cell.movieIndex = indexPath.row

        print("CellDisp \(indexPath.row)")
        if (indexPath.row == movieDBModel!.movies!.count - 1) {
            
            self.loadNextMovies()
        }

        return cell
    }
    
    override public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    private func loadNextMovies() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("carregando proxima pagina!")
        
        movieDBModel!.loadMovies() {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            print("carregou proxima pagina! \(self.movieDBModel!.movies!.count)")
            self.collectionView?.reloadData()
        }
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
    
    public func presentAboutScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :Storyboard.aboutScreenIdentifier) as! AboutViewController
        self.present(viewController, animated: true)
    }

}
