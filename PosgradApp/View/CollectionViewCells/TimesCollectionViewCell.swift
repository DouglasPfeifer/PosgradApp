//
//  TimesCollectionViewCell.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 18/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class TimesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func initLabels(imageURL: String?, description: String) {
        timeImageView.image = nil
        if let url = imageURL {
            timeImageView.downloaded(from: url)
        } else {
            timeImageView.image = UIImage(named: "paper-plane")?.withRenderingMode(.alwaysTemplate)
            timeImageView.tintColor = UIColor.orange
        }
        
        self.descriptionLabel.text = description
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
