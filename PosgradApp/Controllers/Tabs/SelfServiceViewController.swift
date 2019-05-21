//
//  SelfServiceViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 18/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Firebase

class SelfServiceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var selfServiceCollectionView: UICollectionView!
    
    let segment: UISegmentedControl = UISegmentedControl(items: ["DSS-BI", "ESPGTI"])
    
    var database: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initFirebase()
        
        selfServiceCollectionView.delegate = self
        selfServiceCollectionView.dataSource = self
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        retrieveSelfServiceData(completion: {
            (completed) in
        })
        initSegmentedControl()
    }
    
    func initFirebase () {
        database = Firestore.firestore()
        let settings = database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        database.settings = settings
    }
    
    func initSegmentedControl () {
        segment.sizeToFit()
        segment.tintColor = UIColor.black
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        
        segment.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        
        self.navigationItem.titleView = segment
    }
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        self.selfServiceCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.selfServiceCollectionView.frame.width
        return CGSize(width: (collectionViewWidth/2 - 24), height: (collectionViewWidth/2 - 24))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selfServiceCell", for: indexPath) as! SelfServiceCollectionViewCell
        
        cell.initLabels(image: UIImage(named: "paper-plane")!, description: "Descrição de teste um pouco maior que o normal", type: "PDF")
        return cell
    }

    func retrieveSelfServiceData (completion: @escaping (Bool) -> ()) {
        database.collection(SelfServiceKeys.collectionKey).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                for document in querySnapshot!.documents {
                    print(document)
                    if let documentData = document.data() as? [String : Any] {
                        let admins = documentData[SelfServiceKeys.adminsKey] as? [String]
                        let newName = documentData[MissionKeys.nameKey] as? String
                        var newOrder = documentData[MissionKeys.orderKey] as? Int
                        if newOrder == nil {
                            if let newOrderString = documentData[MissionKeys.orderKey] as? String {
                                newOrder = Int(newOrderString)
                            }
                        }
                        let newSeason = documentData[MissionKeys.seasonKey] as? DocumentReference
                        let seasonName = newSeason?.documentID
                        var seasonInt = 0
                        if let someSeason = Seasons(rawValue: seasonName!) {
                            switch someSeason {
                            case .season1:
                                seasonInt = 0
                            case .season2:
                                seasonInt = 1
                            case .season3:
                                seasonInt = 2
                            case .season4:
                                seasonInt = 3
                            case .season5:
                                seasonInt = 4
                            case .season6:
                                seasonInt = 5
                            case .season7:
                                seasonInt = 6
                            case .season8:
                                seasonInt = 7
                            default:
                                seasonInt = 0
                            }
                        } else {
                            seasonInt = 0
                        }
                        
                        // print("seasonName: ", seasonName, "missionSeasonInt: ", seasonInt, "missionName: ", newName!)
                        
                        let newMission = Mission(description: newDescription, name: newName, order: newOrder, season: seasonName, ID: document.documentID)
                        self.missions[document.documentID] = newMission
                        self.missionsOrder[seasonInt][newOrder! - 1] = document.documentID
                    }
                }
                completion(true)
            }
        }
    }
}
