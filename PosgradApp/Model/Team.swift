//
//  Team.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation
import Firebase

class Team {
    var reference : DocumentReference?
    var avatar : DocumentReference?
    var ID : String? // Também é o nome
    var activitiesByPhase = [Int: [TeamActivity]]() // Each position represents one phase (0 = Passport, 1 = Curiosity, 2 = Discovery, 3 =                                           Startup)
    var scoreArrayDic = [[String: Double]?]() // Cada posição do array corresponde a uma temporada (temporada 1, temporada 2..), cada dicionário possui a missão e a pontuação ["discovery" : 10]
    
    init(reference: DocumentReference?, avatar: DocumentReference?, ID: String?) {
        if let newAvatar = avatar {
            self.avatar = newAvatar
        } else {
            self.avatar = nil
        }
        if let newID = ID {
            self.ID = newID
        } else {
            self.ID = nil
        }
        if let newReference = reference {
            self.reference = newReference
        } else {
            self.reference = nil
        }
    }
    
    func updateScore (phase: Int, mission: String, newScore: Double) {
        if self.scoreArrayDic.count > phase {
            if let scoreArray = self.scoreArrayDic[phase] {
                if let presentScore = scoreArray[mission] {
                    self.scoreArrayDic[phase]![mission] = presentScore + newScore
                } else {
                    self.scoreArrayDic[phase]![mission] = newScore
                }
            } else {
                let newElement = [mission : newScore]
                self.scoreArrayDic[phase] = newElement
            }
        } else {
            let newElement = [mission : newScore]
            self.scoreArrayDic.append(newElement)
        }
    }
}
