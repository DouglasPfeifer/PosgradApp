//
//  TimesViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 18/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Firebase

class TimesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var timesCollectionView: UICollectionView!
    
    var teams = [Team]()
    var selectedTeam: Team?
    
    var database: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesCollectionView.delegate = self
        timesCollectionView.dataSource = self

        self.extendedLayoutIncludesOpaqueBars = true
        
        initFirebase()
        
        retrieveTeams { (completed) in
            if completed {
                self.timesCollectionView.reloadData()
            }
        }
    }
    
    func initFirebase () {
        database = Firestore.firestore()
        let settings = database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        database.settings = settings
    }
    
    // Retrieve all team documents from collection
    func retrieveTeams (completion: @escaping (Bool) -> ()) {
        database.collection(TeamKeys.collectionKey).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                self.teams.removeAll()
                
                for document in querySnapshot!.documents {
                    if let documentData = document.data() as? [String : Any] {
                        let newAvatar = documentData[TeamKeys.avatarKey] as? String
                        let ID = document.documentID
                        let reference = document.reference
                        let newTeam = Team.init(reference: reference, avatar: newAvatar, ID: ID)
                        self.teams.append(newTeam)
                    }
                }
                completion(true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.timesCollectionView.frame.width
        return CGSize(width: (collectionViewWidth/2 - 24), height: (collectionViewWidth/2 - 24))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timesCell", for: indexPath) as! TimesCollectionViewCell
        
        cell.initLabels(imageURL: teams[indexPath.item].avatar, description: teams[indexPath.item].ID!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTeam = teams[indexPath.row]
        performSegue(withIdentifier: "teamsToTeam", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teamsToTeam" {
            let destinationVC = segue.destination as! TeamViewController
            destinationVC.team = selectedTeam!
        }
    }
}
