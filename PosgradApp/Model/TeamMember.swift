//
//  TeamMember.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation
import Firebase

struct TeamMember {
    var course : String?
    var email : String?
    var teamID : DocumentReference?
    var name : String?
    var ID : String?
    var avatar : String?
    
    init (course: String?, email: String?, teamID: DocumentReference?, name: String?, ID: String?, avatar: String?) {
        if let newCourse = course {
            self.course = newCourse
        }
        if let newEmail = email {
            self.email = newEmail
        }
        if let newTeamID = teamID {
            self.teamID = newTeamID
        }
        if let newName = name {
            self.name = newName
        }
        if let newID = ID {
            self.ID = newID
        }
        if let newAvatar = avatar {
            self.avatar = newAvatar
        }
    }
}
