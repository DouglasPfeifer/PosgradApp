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
    var fileURL: String?
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews (name: String, type: String, score: Double, appraiser: String, feedback: String, file: String) {
        self.fileURL = file
        
        self.addSubview(activityType)
        activityType.translatesAutoresizingMaskIntoConstraints = false
        activityType.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        activityType.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        activityType.backgroundColor = UIColor(red: 0/255, green: 143/255, blue: 0/255, alpha: 1)
        activityType.textColor = UIColor.white
        activityType.layer.masksToBounds = true
        activityType.layer.cornerRadius = 6
        activityType.font = UIFont.systemFont(ofSize: 15) // UIFont(name: Font.pixel, size: 15)
        activityType.text = String(format: " %@ ", type)
        
        self.addSubview(showActivityDetails)
        showActivityDetails.translatesAutoresizingMaskIntoConstraints = false
        showActivityDetails.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        showActivityDetails.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        showActivityDetails.rightAnchor.constraint(lessThanOrEqualTo: activityType.leftAnchor, constant: -8).isActive = true
        showActivityDetails.setTitleColor(UIColor.blue, for: .normal)
        showActivityDetails.setTitle(name, for: .normal)
        showActivityDetails.titleLabel?.font = UIFont.systemFont(ofSize: 17) //UIFont(name: Font.pixel, size: 17)
        
        self.addSubview(activityScore)
        activityScore.translatesAutoresizingMaskIntoConstraints = false
        activityScore.topAnchor.constraint(equalTo: showActivityDetails.bottomAnchor, constant: 8).isActive = true
        activityScore.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        activityScore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        activityScore.font = UIFont.systemFont(ofSize:  17) //UIFont(name: Font.pixel, size: 17)
        activityScore.text = "Pontuacao: \(Int(score))"
        activityScore.numberOfLines = 0
        
        self.addSubview(activityAppraiser)
        activityAppraiser.translatesAutoresizingMaskIntoConstraints = false
        activityAppraiser.topAnchor.constraint(equalTo: activityScore.bottomAnchor, constant: 8).isActive = true
        activityAppraiser.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        activityAppraiser.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        activityAppraiser.font = UIFont.systemFont(ofSize: 17) //UIFont(name: Font.pixel, size: 17)
        activityAppraiser.text = "Avaliador: \(appraiser)"
        activityAppraiser.numberOfLines = 0
        
        self.addSubview(activityFeedback)
        activityFeedback.translatesAutoresizingMaskIntoConstraints = false
        activityFeedback.topAnchor.constraint(equalTo: activityAppraiser.bottomAnchor, constant: 8).isActive = true
        activityFeedback.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        activityFeedback.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        activityFeedback.font = UIFont.systemFont(ofSize: 17) //UIFont(name: Font.pixel, size: 17)
        activityFeedback.text = "Feedback: \(feedback)"
        activityFeedback.numberOfLines = 0
        
        self.addSubview(showActivityFile)
        showActivityFile.translatesAutoresizingMaskIntoConstraints = false
        showActivityFile.topAnchor.constraint(equalTo: activityFeedback.bottomAnchor, constant: 8).isActive = true
        showActivityFile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        showActivityFile.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        showActivityFile.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        showActivityFile.setTitle("Clique aqui para ver o Feedback", for: .normal)
        showActivityFile.setTitleColor(UIColor.red, for: .normal)
        showActivityFile.titleLabel?.font = UIFont.systemFont(ofSize: 17) //UIFont(name: Font.pixel, size: 17)
        showActivityFile.addTarget(self, action: #selector(openFeedback), for: .touchUpInside)
    }
    
    @objc func openFeedback() {
        guard let url = URL(string: fileURL!) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
