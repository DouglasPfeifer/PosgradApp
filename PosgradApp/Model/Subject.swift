//
//  Subject.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 22/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation
import UIKit

struct Subject {
    var arrayLearningObject : [Any]?
    var image : String?
    var name : String?
    
    init(arrayLearningObject: [Any], image: String, name: String) {
        self.arrayLearningObject = arrayLearningObject
        self.image = image
        self.name = name
    }
}
