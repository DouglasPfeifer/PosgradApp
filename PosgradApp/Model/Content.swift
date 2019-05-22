//
//  Content.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 22/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation

struct Content {
    var format : String?
    var link : String?
    var name : String
    var type : String?
    
    init(format: String, link: String, name: String, type: String) {
        self.format = format
        self.link = link
        self.name = name
        self.type = type
    }
}
