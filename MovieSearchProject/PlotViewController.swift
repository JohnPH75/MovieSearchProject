//
//  PlotViewController.swift
//  MovieSearchProject
//
//  Created by John Hussain on 10/5/16.
//  Copyright © 2016 John Hussain. All rights reserved.
//

import Foundation
import UIKit

class PlotViewController: UITableViewController {
    
    var movie: Movie?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fullPlotText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        self.fullPlotText.hidden = true
        
        if movie != nil {
            self.assignData()
            
        }
        
        let navBarColor = navigationController!.navigationBar
        navBarColor.barTintColor = UIColor.yellowColor()
        navBarColor.alpha = 1
        //navBarColor.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 20)!]
        
        let backButton = UIBarButtonItem(title: "🔙", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 21)!], forState: UIControlState.Normal)
        backButton.tintColor = UIColor.redColor()
        
    }
    func backTapped() {
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func assignData() {
        
        self.fullPlotText.text = movie?.plot
        self.fullPlotText.hidden = false
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
}