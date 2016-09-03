//
//  OMDBAPIClient.swift
//  MovieSearchProject
//
//  Created by John Hussain on 9/3/16.
//  Copyright © 2016 John Hussain. All rights reserved.
//

import UIKit

class OMDBAPIClient {
    
    static let sharedInstance = OMDBAPIClient()
    
    var movieList = [Movie]()
    
    private init() {}
    
    func getMovies(title: String) {
        
        // movies by title
        let path = "https://www.omdbapi.com/?s=\(title)&r=json"
        let url = NSURL(string: path)
        
        print(url)
        
        let jsonData = NSData(contentsOfURL: url!)
        
        self.movieList.removeAll()
        
        do {
            // JSON deserialization
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments)
            
            // verify results
            if let list = json["Search"] as? [[String: AnyObject]] {
                for item in list {
                    let movie = Movie()
                    movie.title = item["Title"] as? String
                    movie.year = item["Year"] as? String
                    movie.id = item["imdbID"] as? String
                    
                    self.movieList.append(movie)
                }
                
            }
            // update interface
            NSNotificationCenter.defaultCenter().postNotificationName("didAddMovie", object: self)
            
        } catch {
            print("Error")
        }
    }
}
