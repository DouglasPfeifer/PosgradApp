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
    
    private var displayLink: CADisplayLink?
    
    // Animation values
    // Values for 0 to 100 score animation
    var scoreStartValue: Double = 0
    var scoreAnimationDuration: Double = 1.5
    var scoreAnimationStartDate: Date?
    
    /*
    // Values for letter by letter animation
    var missionDescriptionSecPerWord: Double = 0.025
    var constructedMissionDescriptionString = ""
    var lastShownMissionDescriptionLabelTextIndex = -1
    */
    
    /*
    // Values for letter by letter foreground color animation
    var missionDescriptionSecPerWord: Double = 0.25
    var lastShownMissionDescriptionLabelTextIndex = -1
    var missionDescriptionStringAttributes = [NSAttributedStringKey.foregroundColor : UIColor.clear]
    var missionDescriptionAttrString : NSMutableAttributedString?
    var lastLetterRangeToShow = -1
    */
    
    /*
    // Values for word by word color animation
    var missionDescriptionSecPerWord: Double = 0.15
    var missionDescriptionStringAttributes = [NSAttributedStringKey.foregroundColor : UIColor.clear]
    var missionDescriptionAttrString : NSMutableAttributedString?
    var missionDescriptionArrOfWords = [String]()
    var lastShownWordIndex = 0
    var lastWordToShowIndex: Int = -1
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true

        initNavigationBar()
        
        initScrollView()
        
        //missionDescriptionAttrString = NSMutableAttributedString(string: mission!.description!, attributes: missionDescriptionStringAttributes)
        //missionDescriptionArrOfWords = mission!.description!.components(separatedBy: " ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initViewLabels()
        scoreAnimationStartDate = Date()
        startDisplayLink()
        
        UIView.animate(withDuration: 1.5, animations: {
            self.missionDescriptionLabel.alpha = 1.0
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopDisplayLink()
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
        missionNameLabel.font = UIFont.systemFont(ofSize: 24) //UIFont(name: Font.pixel, size: 24)
        missionNameLabel.text = mission?.name
        missionNameLabel.textAlignment = .center
        missionNameLabel.numberOfLines = 0
        
        scrollView.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 16).isActive = true
        scoreLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        scoreLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        scoreLabel.numberOfLines = 0
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.systemFont(ofSize: 20) //UIFont(name: Font.pixel, size: 20)
        scoreLabel.text = "Pontuação: \(Int(totalScore!))"
        
        activityStackView.removeAll()
        if let activities = missionActivities {
            for activity in activities {
                let newActivityView = ActivityDetailsView()
                
                newActivityView.initSubviews(name: activity.name!, type: activity.type!, score: Double(activity.score!), appraiser: activity.appraiser!, feedback: activity.feedback!, file: activity.file!)
                
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
            missionDescriptionLabel.bottomAnchor.constraint(equalTo: lastAtivity.topAnchor, constant: -24).isActive = true
        } else {
            missionDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24).isActive = true
        }
        missionDescriptionLabel.font = UIFont.systemFont(ofSize: 16) //UIFont(name: Font.pixel, size: 16)
        missionDescriptionLabel.numberOfLines = 0
        missionDescriptionLabel.alpha = 0 // For whole text fade in
        missionDescriptionLabel.text = mission?.description // For whole text fade in
        //missionDescriptionLabel.attributedText = missionDescriptionAttrString // For word by word animation this line needs to be commented
        missionDescriptionLabel.textAlignment = .justified
    }
    
    func startDisplayLink() {
        stopDisplayLink() // make sure to stop a previous running display link
        
        // create displayLink & add it to the run-loop
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        
        displayLink.add(to: .main, forMode: .commonModes)
        self.displayLink = displayLink
    }
    
    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc func handleUpdate () {
        let now = Date()
        // The time in secods since the animation started
        let elapsedTime = now.timeIntervalSince(scoreAnimationStartDate!)
        // The percentage of desired time completed (0.0 = just started, 1.0 = just finished)
        let percentage = elapsedTime / scoreAnimationDuration
        
        if elapsedTime > scoreAnimationDuration {
            self.scoreLabel.text = "Pontuação: \(Int(totalScore!))"
        } else {
            // The value shown to the user (starts in "scoreStartValue", ends in "totalScore")
            let value = scoreStartValue + percentage * (totalScore! - scoreStartValue)
            self.scoreLabel.text = "Pontuação: \(Int(value))"
        }
        
        /*
        // Letter by letter string animation
        if let missionDescriptionString = mission?.description {
            if missionDescriptionString.count == self.missionDescriptionLabel.text?.count {
                self.missionDescriptionLabel.text = mission?.description
            } else {
                let wordIndexToShow = Int(elapsedTime/missionDescriptionSecPerWord)
                if wordIndexToShow != lastShownMissionDescriptionLabelTextIndex {
                    lastShownMissionDescriptionLabelTextIndex = wordIndexToShow
                    
                    constructedMissionDescriptionString = String(missionDescriptionString.prefix(lastShownMissionDescriptionLabelTextIndex))
                    missionDescriptionLabel.text = constructedMissionDescriptionString
                }
            }
        }
        */
        
        /*
        // Letter by letter color animation
        if let missionDescriptionString = missionDescriptionLabel.attributedText?.string {
            let elapsedTime = now.timeIntervalSince(scoreAnimationStartDate!)
            let wordRangeToShow = Int(elapsedTime/missionDescriptionSecPerWord)
            if wordRangeToShow <= missionDescriptionString.count/2 {
                if lastLetterRangeToShow != wordRangeToShow {
                    if lastLetterRangeToShow == -1 {
                        lastLetterRangeToShow = 0
                    }
                    let range = NSRange(location: lastLetterRangeToShow, length: wordRangeToShow + 1)
                    lastLetterRangeToShow = wordRangeToShow

                    self.missionDescriptionAttrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: range)
                    self.missionDescriptionLabel.attributedText = self.missionDescriptionAttrString
                }
            }
        }
        */
        
        /*
        // Word by word color animation
        if let missionDescriptionString = missionDescriptionLabel.attributedText?.string {
            let elapsedTime = now.timeIntervalSince(scoreAnimationStartDate!)
            let wordToShowIndex = Int(elapsedTime/missionDescriptionSecPerWord)
            
            if wordToShowIndex < missionDescriptionArrOfWords.count {
                
                if lastWordToShowIndex != wordToShowIndex {
                    lastWordToShowIndex = wordToShowIndex

                    let wordToShow = " \(missionDescriptionArrOfWords[wordToShowIndex])"
                    var numLettersToShow = wordToShow.count
                    if lastShownWordIndex == 0 {
                        numLettersToShow -= 1
                    }
                    
                    let range = NSRange(location: lastShownWordIndex, length: numLettersToShow)
                    lastShownWordIndex = lastShownWordIndex + numLettersToShow
                    
                    self.missionDescriptionAttrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: range)

                    UIView.transition(with: self.missionDescriptionLabel, duration: missionDescriptionSecPerWord, options: [.transitionCrossDissolve], animations: {
                        self.missionDescriptionLabel.attributedText = self.missionDescriptionAttrString
                    }, completion: nil)
                }
            } else {
                self.missionDescriptionAttrString = NSMutableAttributedString(string: mission!.description!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
                self.missionDescriptionLabel.attributedText = self.missionDescriptionAttrString
            }
        }
        */
    }
}
