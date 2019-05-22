//
//  SeasonSelectionTableViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 19/04/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

protocol ClassSeasonSelectionDelegate: class {
    func seasonSelected (season: Int)
}

class SeasonSelectionTableViewController: UITableViewController {

    weak var delegate: ClassSeasonSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Seasons.order.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true) {
            self.delegate?.seasonSelected(season: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonSelectionCell", for: indexPath) as! SeasonSelectionTableViewCell

        cell.seasonLabel.text = Seasons.order[indexPath.row].rawValue
        
        return cell
    }
}
