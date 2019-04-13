//
//  NewsViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newsTableView: UITableView!
    
    let segment: UISegmentedControl = UISegmentedControl(items: ["Breaking-News", "Notifications"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        initSegmentedControl()
    }
    
    func initSegmentedControl () {
        segment.sizeToFit()
        segment.tintColor = UIColor.black
        //        segment.backgroundColor = UIColor.black
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        
        segment.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        
        self.navigationItem.titleView = segment
    }
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        self.newsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segment.selectedSegmentIndex == 0 {
            return 141
        } else {
            return 91
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segment.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "breakingNewsCell", for: indexPath) as! BreakingNewsTableViewCell
            cell.newsImageView?.contentMode = .scaleAspectFit
            cell.newsImageView?.layer.cornerRadius = 52
            cell.newsImageView?.layer.masksToBounds = true
            cell.newsImageView?.image = UIImage(named: "techNews")
            cell.titleLabel.text = String(format: "Título de notícia %d", indexPath.row)
            cell.descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis accumsan interdum turpis, ut pulvinar nisi volutpat ut. Nam nec luctus justo, at pharetra orci. Aliquam ac lacinia dolor."
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationsTableViewCell
            cell.titleLabel.text = String(format: "Título de notificação %d", indexPath.row)
            cell.descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis accumsan interdum turpis, ut pulvinar nisi volutpat ut. Nam nec luctus justo, at pharetra orci. Aliquam ac lacinia dolor."
            return cell
        }
    }

}
