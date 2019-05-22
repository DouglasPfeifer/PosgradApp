//
//  SelfServiceCourseCicleView.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 21/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

protocol ClassSelfServiceCellDelegate: class {
    func segueToEmphasis(cicle: Int, emphasis: String)
}

class SelfServiceCourseCicleView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let masterView = UIView()
    let cicleLabel = UILabel()
    let containerEmphasesTableViewView = UIView()
    let emphasesTableView = UITableView()
    
    var emphases = [String]()
    var cicle : Int?
    
    weak var delegate: ClassSelfServiceCellDelegate?
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews (cicle: Int, emphases: [String]) {
        self.emphases = emphases
        self.cicle = cicle
        
        self.addSubview(masterView)
        masterView.translatesAutoresizingMaskIntoConstraints = false
        masterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        masterView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        masterView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        masterView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        masterView.backgroundColor = UIColor.white
        
        self.masterView.addSubview(cicleLabel)
        cicleLabel.translatesAutoresizingMaskIntoConstraints = false
        cicleLabel.topAnchor.constraint(equalTo: self.masterView.topAnchor, constant: 8).isActive = true
        cicleLabel.leftAnchor.constraint(equalTo: self.masterView.leftAnchor, constant: 16).isActive = true
        cicleLabel.rightAnchor.constraint(equalTo: self.masterView.rightAnchor, constant: -16).isActive = true
        cicleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cicleLabel.textColor = UIColor.black
        cicleLabel.layer.masksToBounds = true
        cicleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cicleLabel.text = String(format: "%dª onda", cicle)
        
        self.masterView.addSubview(containerEmphasesTableViewView)
        containerEmphasesTableViewView.translatesAutoresizingMaskIntoConstraints = false
        containerEmphasesTableViewView.topAnchor.constraint(equalTo: self.cicleLabel.bottomAnchor, constant: 8).isActive = true
        containerEmphasesTableViewView.leftAnchor.constraint(equalTo: self.masterView.leftAnchor, constant: 8).isActive = true
        containerEmphasesTableViewView.rightAnchor.constraint(equalTo: self.masterView.rightAnchor, constant: -8).isActive = true
        containerEmphasesTableViewView.bottomAnchor.constraint(equalTo: self.masterView.bottomAnchor, constant: -8).isActive = true
        containerEmphasesTableViewView.backgroundColor = UIColor.clear
        containerEmphasesTableViewView.layer.shadowColor = UIColor.black.cgColor
        containerEmphasesTableViewView.layer.shadowRadius = 3
        containerEmphasesTableViewView.layer.shadowOpacity = 0.25
        containerEmphasesTableViewView.layer.shadowOffset = CGSize.zero
        
        self.containerEmphasesTableViewView.addSubview(emphasesTableView)
        emphasesTableView.translatesAutoresizingMaskIntoConstraints = false
        emphasesTableView.topAnchor.constraint(equalTo: self.containerEmphasesTableViewView.topAnchor, constant: 0).isActive = true
        emphasesTableView.leftAnchor.constraint(equalTo: self.containerEmphasesTableViewView.leftAnchor, constant: 0).isActive = true
        emphasesTableView.rightAnchor.constraint(equalTo: self.containerEmphasesTableViewView.rightAnchor, constant: 0).isActive = true
        emphasesTableView.bottomAnchor.constraint(equalTo: self.containerEmphasesTableViewView.bottomAnchor, constant: 0).isActive = true
        
        emphasesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "emphasisCell")
        emphasesTableView.delegate = self
        emphasesTableView.dataSource = self
        emphasesTableView.isScrollEnabled = false
        
        emphasesTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emphases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emphasisCell", for: indexPath)
        cell.textLabel?.text = emphases[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let adjustedCicleForSegue = self.cicle! - 1
        delegate?.segueToEmphasis(cicle: adjustedCicleForSegue, emphasis: self.emphases[indexPath.row])
    }
}
