//
//  MissionDetailsViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 13/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class MissionDetailsViewController: UIViewController {

    var scrollView = UIScrollView()
    var missionNameLabel = UILabel()
    var scoreLabel = UILabel()
    var missionDescriptionLabel = UILabel()
    var activityStackView = [UIView]()

    var team: Team?
    var season: Int?
    var mission: Mission?
    var totalScore: Double?
    var missionActivities: [TeamActivity]?
    
    // Animation values
    var scoreStartValue: Double = 0
    var scoreAnimationDuration: Double = 1.5
    var scoreAnimationStartDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true

        initNavigationBar()
        
        initScrollView()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .defaultRunLoopMode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initViewLabels()
    }
    
    func initNavigationBar () {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(format: "%dª Temporada", (season! + 1)), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.title = team!.ID!
    }
    
    func initScrollView () {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func initViewLabels () {
        scrollView.addSubview(missionNameLabel)
        missionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        missionNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        missionNameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        missionNameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        missionNameLabel.font = UIFont(name: "pixelmix", size: 24)
        missionNameLabel.text = mission?.name?.replacingOccurrences(of: "ã", with: "a")
        missionNameLabel.textAlignment = .center
        missionNameLabel.numberOfLines = 0
        
        scrollView.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 16).isActive = true
        scoreLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        scoreLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        scoreLabel.numberOfLines = 0
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "pixelmix", size: 20)
        scoreLabel.text = "Pontuação: \(Int(totalScore!))"
        
        activityStackView.removeAll()
        if let activities = missionActivities {
            for activity in activities {
                let newActivityView = ActivityDetailsView()
                
                newActivityView.initSubviews(name: activity.name!, type: activity.type!, score: Double(activity.score!), appraiser: activity.appraiser!, feedback: activity.feedback!)
                
                scrollView.addSubview(newActivityView)
                
                newActivityView.translatesAutoresizingMaskIntoConstraints = false
                
                if activityStackView.isEmpty {
                    newActivityView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                    newActivityView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                    newActivityView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
                } else {
                    newActivityView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                    newActivityView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                    newActivityView.bottomAnchor.constraint(equalTo: activityStackView.last!.topAnchor, constant: -8).isActive = true
                }
                
                newActivityView.backgroundColor = UIColor.white
                newActivityView.layer.cornerRadius = 6
                newActivityView.layer.shadowColor = UIColor.black.cgColor
                newActivityView.layer.shadowRadius = 3
                newActivityView.layer.shadowOpacity = 0.25
                newActivityView.layer.shadowOffset = CGSize.zero
                
                activityStackView.append(newActivityView)
            }
        }
        
        scrollView.addSubview(missionDescriptionLabel)
        missionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        missionDescriptionLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 24).isActive = true
        missionDescriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        missionDescriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        if let lastAtivity = activityStackView.last {
            missionDescriptionLabel.bottomAnchor.constraint(equalTo: lastAtivity.topAnchor, constant: -16).isActive = true
        } else {
            missionDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        }
        missionDescriptionLabel.font = UIFont(name: "pixelmix", size: 16)
        missionDescriptionLabel.numberOfLines = 0
        missionDescriptionLabel.text = mission?.description?.replacingOccurrences(of: "ã", with: "a").replacingOccurrences(of: "ç", with: "c")
        missionDescriptionLabel.textAlignment = .justified
    }
    
    @objc func handleUpdate () {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(scoreAnimationStartDate)
        
        if elapsedTime > scoreAnimationDuration {
            self.scoreLabel.text = "Pontuação: \(Int(totalScore!))"
        } else {
            let percentage = elapsedTime / scoreAnimationDuration
            let value = percentage * (totalScore! - scoreStartValue)
            self.scoreLabel.text = "Pontuação: \(Int(value))"
        }
    }
}
