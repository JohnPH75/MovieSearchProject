//
//  DetailViewController.swift
//  MovieSearchProject
//
//  Created by John Hussain on 9/20/16.
//  Copyright © 2016 John Hussain. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UITableViewController {
    
    var movie: Movie?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var rated: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var plotText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var fullPlotButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController!.navigationBar.tintColor = UIColor(red:0.839, green:0.109, blue:0, alpha:1)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        self.hideLabels()
        
        if movie != nil {
            self.assignData()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.loadData(_:)), name: "didUpdateMovie", object: nil)
        
        let navBarColor = navigationController!.navigationBar
        navBarColor.barTintColor = UIColor.yellowColor()
        navBarColor.alpha = 1
        navBarColor.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 20)!]
        
        let backButton = UIBarButtonItem(title: "🔙", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(movieSearchTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 15)!], forState: UIControlState.Normal)
        backButton.tintColor = UIColor.redColor()
        
    }
    func movieSearchTapped() {
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadData(notification: NSNotification) {
        self.movie = notification.userInfo!["movie"] as? Movie
        self.assignData()
    }
    
    func assignData() {
        self.title = movie!.title!
        self.titleLabel.text = self.movie!.title!
        self.yearLabel.text = "(" + self.movie!.year! + ")"
        self.genreLabel.text = self.movie!.runtime! + " | " + self.movie!.genre!
        self.countryLabel.text = self.movie!.country!
        self.languageLabel.text = self.movie!.language!
        self.ratedLabel.text = self.movie!.rated!
        self.directorLabel.text = self.movie!.director!
        self.plotText.text = self.movie!.plot!
        if let url  = NSURL(string: self.movie!.poster!),
            data = NSData(contentsOfURL: url) {
            self.imageView.image = UIImage(data: data)
        }
        
        self.showLabels()
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
    
    func hideLabels() {
        self.titleLabel.hidden = true
        self.yearLabel.hidden = true
        self.genreLabel.hidden = true
        self.director.hidden = true
        self.directorLabel.hidden = true
        self.country.hidden = true
        self.countryLabel.hidden = true
        self.language.hidden = true
        self.languageLabel.hidden = true
        self.rated.hidden = true
        self.ratedLabel.hidden = true
        self.plotText.hidden = true
        self.imageView.hidden = true
    }
    
    func showLabels() {
        self.titleLabel.hidden = false
        self.yearLabel.hidden = false
        self.genreLabel.hidden = false
        self.director.hidden = false
        self.directorLabel.hidden = false
        self.country.hidden = false
        self.countryLabel.hidden = false
        self.language.hidden = false
        self.languageLabel.hidden = false
        self.rated.hidden = false
        self.ratedLabel.hidden = false
        self.plotText.hidden = false
        self.imageView.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextView"
        {
            let destinationVC = segue.destinationViewController as! PlotViewController
            
            if let movie = self.movie
            {
                destinationVC.movie = movie
            }
        }
    }
    
}