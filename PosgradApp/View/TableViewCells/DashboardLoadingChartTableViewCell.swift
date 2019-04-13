//
//  DashboardLoadingChartTableViewCell.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 04/04/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class DashboardLoadingChartTableViewCell: UITableViewCell {

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let loadingLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
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
        //loadingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        //loadingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true
        loadingLabel.text = "Carregando..."
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = UIColor.lightGray
    }
}
