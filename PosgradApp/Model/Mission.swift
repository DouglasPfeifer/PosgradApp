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
            self.description = newDescription
        }
        if let newName = name {
            self.name = newName
        }
        if let newOrder = order {
            self.order = newOrder
        }
        if let newSeason = season {
            self.season = newSeason
        }
        if let newID = ID {
            self.ID = newID
        }
    }
}
