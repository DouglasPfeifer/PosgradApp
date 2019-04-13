//
//  Activity.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation
import Firebase

class TeamActivity {
    var file : String?
    var appraiser : String?
    var feedback: String?
    var member: DocumentReference?
    var mission: DocumentReference?
    var name: String?
    var score: Int?
    var type: String?
    var team : DocumentReference?
    var ID : String?
    
    init (file: String?, appraiser: String?, feedback: String?, member: DocumentReference?, mission: DocumentReference?, name: String?, score: Int?, type: String?, team: DocumentReference?, ID: String?) {
        
        if let newFile = file {
            self.file = newFile
        }
        if let newAppraiser = appraiser {
            self.appraiser = newAppraiser
        }
        if let newFeedback = feedback {
            self.feedback = newFeedback
        }
        if let newMember = member {
            self.member = newMember
        }
        if let newMission = mission {
            self.mission = newMission
        }
        if let newName = name {
            self.name = newName
        }
        if let newScore = score {
            self.score = newScore
        }
        if let newType = type {
            self.type = newType
        }
        if let newTeam = team {
            self.team = newTeam
        }
        if let newID = ID {
            self.ID = newID
        }
    }
}
