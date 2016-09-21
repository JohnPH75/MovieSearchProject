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
        
        searchBarUI()
        navBarUI()
    }
    
    @IBAction func searchClear(sender: AnyObject) {
        
        searchBar.text = ""
        self.manager.movieList.removeAll()
        collectionView?.reloadData()
        manager.pageNumber = 1
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let searchResult = searchBar.text
        guard let unwrappedSearch = searchResult else {return}
        
        if unwrappedSearch == ""
        {
            self.manager.movieList.removeAll()
            
            dispatch_async(dispatch_get_main_queue(),{
                self.collectionView.reloadData()
            })
            manager.pageNumber = 1
        }
        else
        {
            self.manager.movieList.removeAll()
            
            
            dispatch_async(dispatch_get_main_queue(),{
                self.manager.getMovies(unwrappedSearch)
                self.collectionView.reloadData()
            })
            
            
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == manager.movieList.count - 1 {
            if let searchText = searchBar.text
            {
                dispatch_async(dispatch_get_main_queue(),
                               {
                                self.manager.getNextPage(searchText)
                                self.manager.getMovies(searchText)
                                self.collectionView.reloadData()
                })
            }
            
        }
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
        
        //        cell.labelCell.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //        cell.labelCell.numberOfLines = 0
        //        cell.labelCell.sizeToFit()
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
        //let url: NSURL = NSURL(string: imageURL!)!
        //let data:NSData = NSData(contentsOfURL: url)!
        //cell.imageCell.image = UIImage(data: data)
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            let cell = sender as! UICollectionViewCell
            let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
            
            if manager.movieList[indexPath.row].director != nil {
                let destView = segue.destinationViewController as! DetailViewController
                destView.movie = manager.movieList[indexPath.row]
            } else {
                self.manager.getMovieInfo(manager.movieList[indexPath.row])
            }
        }
    }
    
    func searchBarUI() {
        searchBar.barTintColor = UIColor.blackColor() //border
        searchBar.bringSubviewToFront(view)
        if let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            //Magnifying glass
            glassIconView.image = glassIconView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            glassIconView.tintColor = UIColor.yellowColor()
            textFieldInsideSearchBar.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 17)
            textFieldInsideSearchBar.textColor = UIColor.yellowColor() //text being typed
        }
        UILabel.appearanceWhenContainedInInstancesOfClasses([UITextField.self]).textColor = UIColor.yellowColor()  //placeholder text
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview .isKindOfClass(UITextField) {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.blackColor()
                }
            }
        }
    }
}