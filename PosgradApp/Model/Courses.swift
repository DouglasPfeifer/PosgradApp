//
//  Courses.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 21/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation

struct Course {
    var cicles : Int?
    var description : String?
    var emphasis : [String]?
    var image : String?
    var missions : Int?
    var seasons : Int?
    
    init(cicles: Int?, description: String?, emphasis: [String]?, image: String?, missions: Int?, seasons: Int?) {
        self.cicles = cicles
        self.description = description
        self.emphasis = emphasis
        self.image = image
        self.missions = missions
        self.seasons = seasons
    }
}
