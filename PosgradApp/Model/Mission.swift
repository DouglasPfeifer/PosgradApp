//
//  Mission.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation
import Firebase

struct Mission {
    var description : String?
    var name : String?
    var order : Int?
    var season : DocumentReference?
    var ID : String?
    
    init(description: String?, name: String?, order: Int?, season: DocumentReference?, ID: String?) {
        
        if let newDescription = description {
            self.description = description
        }
        if let newName = name {
            self.name = name
        }
        if let newOrder = order {
            self.order = order
        }
        if let newSeason = season {
            self.season = season
        }
        if let newID = ID {
            self.ID = ID
        }
    }
}
