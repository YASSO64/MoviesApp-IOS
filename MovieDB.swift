//
//  MovieDB.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/14/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class MovieDB: Object {

    @objc dynamic var id: String = "";
    @objc dynamic var title: String = "";
    @objc dynamic var overview: String = "";
    @objc dynamic var releaseDate: String = "";
    @objc dynamic var rating: Double = 0.0;
    @objc dynamic var posterPath: String = "";
    @objc dynamic var isFav: Bool = false;
    var trailersKeys = List<String>();
    var reviews = List<ReviewDB>();
    var imageURLPrefix = "https://image.tmdb.org/t/p/w185";
    
    convenience init(value: JSON) {
        self.init();
        self.id = value["id"].stringValue;
        self.title = value["original_title"].stringValue;
        self.posterPath = "\(self.imageURLPrefix)\(value["poster_path"].stringValue)";
        self.overview = value["overview"].stringValue;
        self.releaseDate = value["release_date"].stringValue;
        self.rating = round(value["vote_average"].doubleValue);
    }
}
