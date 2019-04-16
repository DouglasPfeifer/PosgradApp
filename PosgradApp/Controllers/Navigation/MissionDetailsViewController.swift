//
//  MissionDetailsViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 13/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class MissionDetailsViewController: UIViewController {

    var team: Team?
    var season: Int?
    var mission: Mission?
    var totalPoints: Double?
    var missionActivities: [TeamActivity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
        
        print(team)
        print(season)
        print(mission)
        print(totalPoints)
        print(missionActivities)
    }
    
}
