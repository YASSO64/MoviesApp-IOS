//
//  API.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/8/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {
  
    static var apiUrlPrefix = "https://api.themoviedb.org/3";
    static var apiKey = "c63dc675fd259944a36b3b73b4f1f8a9";
    
    class func getMoviesFromApi(view: MoviesCollectionViewController) {
        
        var movies = Array<MovieDB>();
        let requestMoviesUrlStr = "\(self.apiUrlPrefix)/discover/movie";
        let params: Dictionary<String,AnyObject> = ["api_key": apiKey as AnyObject];
        
        Alamofire.request(requestMoviesUrlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            
            switch response.result {
                
            case .failure(let error):
                print(error);
            case .success(let value):
                let json = JSON(value);
                print("movies : \(json)");
                let resArr = json["results"].arrayValue;
                for object in resArr {
                    let movie: MovieDB = MovieDB(value: object);
                    movies.append(movie);
                }
                
                view.loadMovies(movies: movies);
            }
        }
    }
    
    class func getSortedMoviesFromApi(view: MoviesCollectionViewController, sort: String) {
        
        var movies = Array<MovieDB>();
        let requestMoviesUrlStr = "\(self.apiUrlPrefix)/discover/movie";
        let params: Dictionary<String,AnyObject> = ["sort_by": sort as AnyObject, "api_key": apiKey as AnyObject];
        
        Alamofire.request(requestMoviesUrlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in

            switch response.result {
            
                case .failure(let error):
                    print(error);
                case .success(let value):
                    let json = JSON(value);
                    print("movies : \(json)");
                    let resArr = json["results"].arrayValue;
                    for object in resArr {
                        let movie: MovieDB = MovieDB(value: object);
                        movies.append(movie);
                    }

                view.loadMovies(movies: movies);
            }
        }
    }
    
    class func getTrailersFromApi(movieId: String, view: DetailsViewController) {
    
        let params: Dictionary<String,AnyObject> = ["api_key": apiKey as AnyObject];
        let requestTrailersUrlStr = "\(self.apiUrlPrefix)/movie/\(movieId)/videos";
        var trailerKey = "";
        var trailersKeys = Array<String>();
        var movie_id = movieId;
        var detailsViewObj: DetailsViewController = view;
        
        Alamofire.request(requestTrailersUrlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            
            switch response.result {
                
                case .failure(let error):
                    print(error);
                case .success(let value):
                    let json = JSON(value);
                    print("trailers from API: \(json)");
                    let resArr = json["results"].arrayValue;
                    for object in resArr {
                        trailerKey = object["key"].stringValue;
                        trailersKeys.append(trailerKey);
                    }
                print("trailers count from API: \(trailersKeys.count)");
                view.setTrailersCount(trailers_count: trailersKeys.count);
                view.setTrailersKeys(trailersKeysArr: trailersKeys);
                API.getReviewsFromApi(movieId: movie_id, view: detailsViewObj);
            }
        }
    }
    
    class func getReviewsFromApi(movieId: String, view: DetailsViewController) {
        
        let params: Dictionary<String,AnyObject> = ["api_key": apiKey as AnyObject];
        let requestReviewsUrlStr = "\(self.apiUrlPrefix)/movie/\(movieId)/reviews";
        var reviewContent = "";
        var author = "";
        var reviews = Array<ReviewDB>();
        var reviewObj: ReviewDB?
        
        Alamofire.request(requestReviewsUrlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            
            switch response.result {
                
                case .failure(let error):
                    print(error);
                case .success(let value):
                    let json = JSON(value);
                    print("reviews from API: \(json)");
                    let resArr = json["results"].arrayValue;
                    for object in resArr {
                        reviewContent = object["content"].stringValue;
                        author = object["author"].stringValue;
                        reviewObj = ReviewDB(content: reviewContent, author: author);
                        reviews.append(reviewObj!);
                    }
                    
                    print("reviews count from API: \(reviews.count)");
                    view.setReviewsCount(reviews_count: reviews.count);
                    view.setReviews(reviewsArr: reviews);
            }
        }
    }
    
}
