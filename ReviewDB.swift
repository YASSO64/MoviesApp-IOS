//
//  ReviewDB.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/14/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import RealmSwift

class ReviewDB: Object {

    @objc dynamic var content: String = "";
    @objc dynamic var author: String = "";
    
    convenience init(content: String, author: String) {
        self.init();
        self.content = content;
        self.author = author;
    }
}
