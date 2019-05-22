//
//  SubjectTableViewCell.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 22/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
