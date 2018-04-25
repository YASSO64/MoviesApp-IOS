//
//  ReviewModel.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/16/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit
import Foundation

class ReviewModel: NSObject {

    var content: String?;
    var author: String?;
    
    init(content: String, author: String) {
        self.content = content;
        self.author = author;
    }
}
