//
//  DashboardLoadingChartTableViewCell.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 04/04/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class DashboardLoadingChartTableViewCell: UITableViewCell {

    let teamLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let failImageView = UIImageView(image: UIImage(named: "report_problem")?.withRenderingMode(.alwaysTemplate))
    let loadingLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initLoadingCell () {
        self.loadingLabel.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.teamLabel.removeFromSuperview()
        self.failImageView.removeFromSuperview()
        
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
        loadingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        loadingLabel.text = "Carregando..."
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = UIColor.lightGray
    }
    
    func cellDataUnavailable () {
        self.loadingLabel.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.teamLabel.removeFromSuperview()
        self.failImageView.removeFromSuperview()
        
        self.addSubview(teamLabel)
        teamLabel.translatesAutoresizingMaskIntoConstraints = false
        teamLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 19).isActive = true
        teamLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 19).isActive = true
        teamLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -19).isActive = true
        teamLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        teamLabel.font = UIFont.boldSystemFont(ofSize: 17)
        teamLabel.numberOfLines = 0
        teamLabel.textAlignment = .left
        
        self.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        loadingLabel.text = "Os dados desse time não foram atualizados ainda, tente novamente mais tarde."
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .center
        
        self.addSubview(failImageView)
        failImageView.translatesAutoresizingMaskIntoConstraints = false
        failImageView.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 16).isActive = true
        failImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        failImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        failImageView.bottomAnchor.constraint(equalTo: loadingLabel.topAnchor, constant: -16).isActive = true
        failImageView.contentMode = .scaleAspectFit
    }
}
