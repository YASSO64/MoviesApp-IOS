//
//  MovieModel.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/7/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class MovieModel: NSObject {

    var id: String?;
    var title: String?;
    var posterPath: String?;
    var overview: String?
    var releaseDate: String?
    var rating: Double?
    var imageURLPrefix = "https://image.tmdb.org/t/p/w185";
    
    init(movieObj: JSON) {
        self.id = movieObj["id"].stringValue;
        self.title = movieObj["original_title"].stringValue;
        self.posterPath = "\(self.imageURLPrefix)\(movieObj["poster_path"].stringValue)";
        self.overview = movieObj["overview"].stringValue;
        self.releaseDate = movieObj["release_date"].stringValue;
        self.rating = round(movieObj["vote_average"].doubleValue);
    }
}
