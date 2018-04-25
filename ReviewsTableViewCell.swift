//
//  ReviewsTableViewCell.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/12/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTxtView: UITextView!
    @IBOutlet weak var authorLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }

}
