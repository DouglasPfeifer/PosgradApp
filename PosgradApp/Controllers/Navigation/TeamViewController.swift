//
//  TeamViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 22/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Firebase

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var team: Team?
    var members = [TeamMember]()
    
    var database: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initNavigationBar()
        initFirebase()
        
        retrieveTeamMembers { (completed) in
            self.tableView.reloadData()
        }
    }
    
    func initFirebase () {
        database = Firestore.firestore()
        let settings = database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        database.settings = settings
    }
    
    func initNavigationBar () {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = team?.ID
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamMembersCell", for: indexPath) as! TeamMembersTableViewCell
        cell.memberLabel.text = members[indexPath.row].name
        if let imageURL = members[indexPath.row].avatar {
            cell.memberImageView.downloaded(from: imageURL)
        } else {
            cell.memberImageView.image = UIImage(named: "noimage")
        }
        cell.memberImageView.layer.cornerRadius = 39
        cell.memberImageView.contentMode = .scaleAspectFit
        cell.selectionStyle = .none
        return cell
    }
    
    // Retrieve all members from collection
    func retrieveTeamMembers (completion: @escaping (Bool) -> ()) {
        database.collection(TeamMemberKeys.collectionKey).whereField(TeamMemberKeys.teamIDKey, isEqualTo: team!.reference!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                self.members.removeAll()
                for document in querySnapshot!.documents {
                    if let documentData = document.data() as? [String : Any] {
                        let newCourse = documentData[TeamMemberKeys.courseKey] as? String
                        let newEmail = documentData[TeamMemberKeys.emailKey] as? String
                        let newTeamID = documentData[TeamMemberKeys.teamIDKey] as? DocumentReference
                        let newName = documentData[TeamMemberKeys.nameKey] as? String
                        let ID = document.documentID
                        let newAvatar = documentData[TeamMemberKeys.avatarKey] as? String
                        let newTeamMember = TeamMember.init(course: newCourse, email: newEmail, teamID: newTeamID, name: newName, ID: ID, avatar: newAvatar)
                        self.members.append(newTeamMember)
                    }
                }
                completion(true)
            }
        }
    }
}
