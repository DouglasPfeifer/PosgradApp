//
//  SubjectViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 22/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let segment: UISegmentedControl = UISegmentedControl(items: ["Conteúdos", "Atividades"])
    var subjectImageView = UIImageView()
    
    var subject : Subject?
    var contents = [Content]()
    var activities = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initNavigationBar()
        initSegmentedControl()
        initContents()
    }
    
    func initNavigationBar () {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = subject?.name!
    }
    
    func initSegmentedControl () {
        self.segment.sizeToFit()
        self.segment.tintColor = UIColor.black
        self.segment.selectedSegmentIndex = 0
        self.segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        self.segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        
        self.segment.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        self.navigationItem.titleView = self.segment
    }
    
    func initContents () {
        contents.removeAll()
        activities.removeAll()
        for content in subject!.arrayLearningObject! {
            let dictContent = content as! [String: Any]
            let newFormat = dictContent[SubjectsKeys.LearningObjectKeys.format] as? String
            let newLink = dictContent[SubjectsKeys.LearningObjectKeys.link] as? String
            let newName = dictContent[SubjectsKeys.LearningObjectKeys.name] as? String
            let newType = dictContent[SubjectsKeys.LearningObjectKeys.type] as? String
            
            if newType == "C" {
                let newContent = Content(format: newFormat!, link: newLink!, name: newName!, type: newType!)
                contents.append(newContent)
            } else if newType == "A" {
                let newContent = Content(format: newFormat!, link: newLink!, name: newName!, type: newType!)
                activities.append(newContent)
            }
        }
    }
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if segment.titleForSegment(at: segment.selectedSegmentIndex) == "Conteúdos" {
            if contents.count != 0 {
                tableView.separatorStyle = .singleLine
                numOfSections = 1
                tableView.backgroundView = nil
            } else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "Sem Conteúdos."
                noDataLabel.textColor = UIColor.gray
                noDataLabel.textAlignment = .center
                noDataLabel.numberOfLines = 0
                noDataLabel.font = UIFont.systemFont(ofSize: 18)
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
            }
        } else if segment.titleForSegment(at: segment.selectedSegmentIndex) == "Atividades" {
            if activities.count != 0 {
                tableView.separatorStyle = .singleLine
                numOfSections = 1
                tableView.backgroundView = nil
            } else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "Sem atividades."
                noDataLabel.textColor = UIColor.gray
                noDataLabel.textAlignment = .center
                noDataLabel.numberOfLines = 0
                noDataLabel.font = UIFont.systemFont(ofSize: 18)
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
            }
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.titleForSegment(at: segment.selectedSegmentIndex) == "Conteúdos" {
            return contents.count
        } else if segment.titleForSegment(at: segment.selectedSegmentIndex) == "Atividades" {
            return activities.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectTableViewCell
        if segment.titleForSegment(at: segment.selectedSegmentIndex) == "Conteúdos" {
            if contents[indexPath.row].format == "pdf" {
                cell.contentImageView.image = UIImage(named: "pdf")
            } else if contents[indexPath.row].format == "video" {
                cell.contentImageView.image = UIImage(named: "youtube")
            } else {
                cell.contentImageView.image = UIImage(named: "noimage")
            }
            cell.contentImageView.contentMode = .scaleAspectFit
            cell.contentTitle.text = contents[indexPath.row].name
            return cell
        } else if segment.titleForSegment(at: segment.selectedSegmentIndex) == "Atividades" {
            if activities[indexPath.row].format == "pdf" {
                cell.contentImageView.image = UIImage(named: "pdf")
            } else if activities[indexPath.row].format == "video" {
                cell.contentImageView.image = UIImage(named: "youtube")
            } else {
                cell.contentImageView.image = UIImage(named: "noimage")
            }
            cell.contentTitle.text = activities[indexPath.row].name
            return cell
        } else {
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment.titleForSegment(at: segment.selectedSegmentIndex) == "Conteúdos" {
            guard let url = URL(string: contents[indexPath.row].link!) else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            guard let url = URL(string: activities[indexPath.row].link!) else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
