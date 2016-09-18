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
                    movie.poster = item["Poster"] as? String
                    
                    self.movieList.append(movie)
                }
                
            }
            // update interface
            NSNotificationCenter.defaultCenter().postNotificationName("didAddMovie", object: self)
            
        } catch {
            print("Error")
        }
    }
    
    func getMovieInfo(movie: Movie) {
        
        // Movies by imdbId
        let path = "https://www.omdbapi.com/?i=\(movie.id)&plot=long&r=json"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            if error != nil {
                print("error")
            }
            
            if let httpResponse = response  as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Error HTTPResponse")
                } else   {
                    
                    do {
                        // JSON deserialization
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                        if let list = json as? [String: AnyObject] {
                            movie.plot = list["Plot"] as? String
                            movie.director = list["Director"] as? String
                            movie.genre = list["Genre"] as? String
                            movie.language = list["Language"] as? String
                            movie.rated = list["Rated"] as? String
                            movie.country = list["Country"] as? String
                            movie.runtime = list["Runtime"] as? String
                            movie.poster = list["Poster"] as? String
                            
                            // Update interface
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let userInfo = ["movie": movie]
                                NSNotificationCenter.defaultCenter().postNotificationName("didUpdateMovie", object: self, userInfo: userInfo)
                            })
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
}
