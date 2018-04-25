//
//  TrailersTableViewCell.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/12/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import UIKit

class TrailersTableViewCell: UITableViewCell {

    @IBOutlet weak var playVideoImgView: UIImageView!
    @IBOutlet weak var trailerTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }

}
