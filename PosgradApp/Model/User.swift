//
//  User.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 28/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation
import Firebase

class User : NSObject {
    @objc dynamic var avatar : UIImage?
    @objc dynamic var course : String?
    @objc dynamic var email : String?
    var team : DocumentReference?
    @objc dynamic var name : String?
    var ID : String?
        
    init(avatar: UIImage?, course: String?, email: String?, team: DocumentReference?, name: String?, ID : String?) {
        if let newCourse = course {
            self.course = newCourse
        }
        if let newEmail = email {
            self.email = newEmail
        }
        if let newTeam = team {
            self.team = newTeam
        }
        if let newName = name {
            self.name = newName
        }
        if let newAvatar = avatar {
            self.avatar = newAvatar
        }
    }
    
    func retrieveUserData (database: Firestore, completion: @escaping (Bool, User?) -> ()) {
        database.collection(TeamMemberKeys.collectionKey).document(self.ID!).getDocument { (document, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false, nil)
            } else {
                if let newDocument = document {
                    if let documentData = newDocument.data() {
                        if let avatarBase64 = documentData[UserKeys.avatarKey] as? String {
                            if let url = URL(string: avatarBase64), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                self.avatar = image
                            }
                        }
                        let newCourse = documentData[UserKeys.courseKey] as? String
                        let newEmail = documentData[UserKeys.emailKey] as? String
                        let newTeam = documentData[UserKeys.teamIDKey] as? DocumentReference
                        let newName = documentData[UserKeys.nameKey] as? String
                        self.course = newCourse
                        self.email = newEmail
                        self.team = newTeam
                        self.name = newName
                        completion(true, self)
                    } else {
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
            }
        }
    }
    
    func retrieveUserAvatar (database: Firestore, completion: @escaping (UIImage) -> ()) {
        
    }
}
