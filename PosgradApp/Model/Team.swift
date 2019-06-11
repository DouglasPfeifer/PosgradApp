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
    var avatar : String?
    var ID : String? // Also is the name
    // Each position of the array represents one Season ([0] = 1ª Temporada, [1] = 2ª Temporada, ...) and each key in the dictionary represents one Phase (0 = Passport, 1 = Curiosity, 2 = Discovery, 3 = Startup), each value of the dictionary has an array with activities and these are the activities of the given Season and the given Phase.
    var activitiesBySeasonByPhase = [
                                        [Int: [TeamActivity]](),
                                        [Int: [TeamActivity]](),
                                        [Int: [TeamActivity]](),
                                        [Int: [TeamActivity]](),
                                        [Int: [TeamActivity]](),
                                        [Int: [TeamActivity]](),
                                        [Int: [TeamActivity]](),
                                        [Int: [TeamActivity]]()
                                    ]
    // [[Int: [TeamActivity]]]()
    // Each position represents one Season ([0] = 1ª Temporada, [1] = 2ª Temporada, ...) and each dictionary has a mission with its score ["discovery" : 10]
    var scoreArrayDic = [[String: Double]?]()
    
    init(reference: DocumentReference?, avatar: String?, ID: String?) {
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
    
    func updateScore (season: Int, mission: String, newScore: Double) {
        if self.scoreArrayDic.count > season {
            if let scoreArray = self.scoreArrayDic[season] {
                if let presentScore = scoreArray[mission] {
                    self.scoreArrayDic[season]![mission] = presentScore + newScore
                } else {
                    self.scoreArrayDic[season]![mission] = newScore
                }
            } else {
                let newElement = [mission : newScore]
                self.scoreArrayDic[season] = newElement
            }
        } else {
            let newElement = [mission : newScore]
            if scoreArrayDic.count != season {
                if scoreArrayDic.count <= season {
                    for index in scoreArrayDic.count...(season - 1) {
                        self.scoreArrayDic.append([String: Double]())
                    }
                }
            }
            self.scoreArrayDic.append(newElement)
        }
    }
}
