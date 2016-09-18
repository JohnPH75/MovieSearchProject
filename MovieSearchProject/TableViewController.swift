//
//  ViewController.swift
//  MovieSearchProject
//
//  Created by John Hussain on 9/3/16.
//  Copyright © 2016 John Hussain. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    let manager = OMDBAPIClient.sharedInstance
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewController.reloadData), name: "didAddMovie", object: nil)
        
       
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    @IBAction func searchClear(sender: AnyObject) {
        searchBar.text = ""
        self.manager.movieList.removeAll()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.manager.movieList.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(self.manager.movieList[indexPath.row].title)
        print(self.manager.movieList[indexPath.row].year)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        let movie = self.manager.movieList[indexPath.row]
        
        cell.textLabel!.text = movie.title
        cell.detailTextLabel!.text = movie.year
        
        return cell
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    // MARK: - Search bar data source
    
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            
        }
    }
    
}

