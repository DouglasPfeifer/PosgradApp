//
//  ActivityDetailsView.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/04/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class ActivityDetailsView: UIView {

    let showActivityDetails = UIButton()
    let activityType = UILabel()
    let activityScore = UILabel()
    let activityAppraiser = UILabel()
    let activityFeedback = UILabel()
    let showActivityFile = UIButton()
    
    func initSubviews (name: String, type: String, score: Double, appraiser: String, feedback: String) {
        self.addSubview(activityType)
        activityType.translatesAutoresizingMaskIntoConstraints = false
        activityType.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        activityType.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        activityType.backgroundColor = UIColor.green
        activityType.textColor = UIColor.black
        activityType.layer.masksToBounds = true
        activityType.layer.cornerRadius = 6
        activityType.font = UIFont.systemFont(ofSize: 15)
        activityType.text = String(format: " %@ ", type)
        
        self.addSubview(showActivityDetails)
        showActivityDetails.translatesAutoresizingMaskIntoConstraints = false
        showActivityDetails.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        showActivityDetails.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        showActivityDetails.rightAnchor.constraint(lessThanOrEqualTo: activityType.leftAnchor, constant: -8).isActive = true
        showActivityDetails.setTitleColor(UIColor.blue, for: .normal)
        showActivityDetails.setTitle(name, for: .normal)
        showActivityDetails.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.addSubview(activityScore)
        activityScore.translatesAutoresizingMaskIntoConstraints = false
        activityScore.topAnchor.constraint(equalTo: showActivityDetails.bottomAnchor, constant: 8).isActive = true
        activityScore.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        activityScore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        let scoreBoldText  = "Pontuação: "
        let scoreAttrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)]
        let scoreAttributedString = NSMutableAttributedString(string: scoreBoldText, attributes: scoreAttrs)
        let scoreNormalText = String(format: "%.0f", score)
        let scoreNormalString = NSMutableAttributedString(string: scoreNormalText)
        scoreAttributedString.append(scoreNormalString)
        activityScore.attributedText = scoreAttributedString
        
        self.addSubview(activityAppraiser)
        activityAppraiser.translatesAutoresizingMaskIntoConstraints = false
        activityAppraiser.topAnchor.constraint(equalTo: activityScore.bottomAnchor, constant: 8).isActive = true
        activityAppraiser.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        activityAppraiser.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        let appraiserBoldText  = "Avaliador: "
        let appraiserAttrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)]
        let appraiserAttributedString = NSMutableAttributedString(string: appraiserBoldText, attributes: appraiserAttrs)
        let appraiserNormalText = appraiser
        let appraiserNormalString = NSMutableAttributedString(string: appraiserNormalText)
        appraiserAttributedString.append(appraiserNormalString)
        activityAppraiser.attributedText = appraiserAttributedString
        activityAppraiser.numberOfLines = 0
        
        self.addSubview(activityFeedback)
        activityFeedback.translatesAutoresizingMaskIntoConstraints = false
        activityFeedback.topAnchor.constraint(equalTo: activityAppraiser.bottomAnchor, constant: 8).isActive = true
        activityFeedback.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        activityFeedback.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        let feedbackBoldText  = "Feedback: "
        let feedbackAttrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)]
        let feedbackAttributedString = NSMutableAttributedString(string: feedbackBoldText, attributes: feedbackAttrs)
        let feedbackNormalText = feedback
        let feedbackNormalString = NSMutableAttributedString(string: feedbackNormalText)
        feedbackAttributedString.append(feedbackNormalString)
        activityFeedback.attributedText = feedbackAttributedString
        activityFeedback.numberOfLines = 0
        
        self.addSubview(showActivityFile)
        showActivityFile.translatesAutoresizingMaskIntoConstraints = false
        showActivityFile.topAnchor.constraint(equalTo: activityFeedback.bottomAnchor, constant: 8).isActive = true
        showActivityFile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        showActivityFile.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        showActivityFile.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        showActivityFile.setTitle("Clique aqui para ver o Feedback", for: .normal)
        showActivityFile.setTitleColor(UIColor.red, for: .normal)
    }
}
