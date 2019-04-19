//
//  SelfServiceCollectionViewCell.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 18/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class SelfServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func initLabels(image: UIImage, description: String, type: String) {
        self.typeImageView.image = image.withRenderingMode(.alwaysTemplate)
        self.typeImageView.tintColor = UIColor.orange
        
        self.descriptionLabel.text = description
        
        self.typeLabel.text = String(format: "%@       ", type)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
