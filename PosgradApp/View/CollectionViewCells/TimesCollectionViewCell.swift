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
    
    func initLabels(image: UIImage, description: String) {
        self.timeImageView.image = image.withRenderingMode(.alwaysTemplate)
        self.timeImageView.tintColor = UIColor.orange
        
        self.descriptionLabel.text = description
        
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
