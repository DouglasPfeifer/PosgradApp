//
//  SubjectCollectionViewCell.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 22/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class SubjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectImageView: UIImageView!
    @IBOutlet weak var sucjectTItleLabel: UILabel!
    
    func initLabels(image: UIImage, description: String) {
        self.subjectImageView.image = image.withRenderingMode(.alwaysTemplate)
        self.subjectImageView.tintColor = UIColor.orange
        
        self.sucjectTItleLabel.text = description
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
