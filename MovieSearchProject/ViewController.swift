//
//  ViewController.swift
//  MovieSearchProject
//
//  Created by John Hussain on 9/18/16.
//  Copyright © 2016 John Hussain. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    let manager = OMDBAPIClient.sharedInstance
    var movie: Movie?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reloadData), name: "didAddMovie", object: nil)
        
        collectionView.backgroundColor = UIColor.lightGrayColor()
        
        navBarUI()
    }
    
    @IBAction func searchClear(sender: AnyObject) {
        
        searchBar.text = ""
        self.manager.movieList.removeAll()
        collectionView?.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.manager.movieList.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Cell \(indexPath.row+1) selected")
        print(self.manager.movieList[indexPath.row].title)
        print(self.manager.movieList[indexPath.row].year)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ViewControllerCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ViewControllerCell
        
        let movie = self.manager.movieList[indexPath.row]
        
        cell.labelCell.text = movie.title
        cell.labelDetailCell.text = movie.year
        
        let imageURL = movie.poster
        if let image = imageURL
        {
            let url = NSURL(string: image)
            if let unwrappedURL = url
            {
                let imagedata = NSData(contentsOfURL: unwrappedURL)
                
                if let unwrappedData = imagedata
                {
                    cell.imageCell.image = UIImage(data: unwrappedData)
                }
            }
        }
        return cell
    }
    
    func reloadData() {
        
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            // replacing characters with %
            let newString = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            manager.getMovies(newString!)
        }
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func navBarUI() {
        let navBarColor = navigationController!.navigationBar
        navBarColor.barTintColor = UIColor.yellowColor()
        navBarColor.alpha = 0.33
        navBarColor.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 25)!]
        
        let backButton = UIBarButtonItem(title: "Search Clear", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(searchClear))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 19)!], forState: UIControlState.Normal)
        backButton.tintColor = UIColor.redColor()
    }
    
    
}