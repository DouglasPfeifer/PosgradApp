//
//  TimesViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 18/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class TimesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var timesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesCollectionView.delegate = self
        timesCollectionView.dataSource = self

        self.extendedLayoutIncludesOpaqueBars = true

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.timesCollectionView.frame.width
        return CGSize(width: (collectionViewWidth/2 - 24), height: (collectionViewWidth/2 - 24))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timesCell", for: indexPath) as! TimesCollectionViewCell
        
        cell.initLabels(image: UIImage(named: "paper-plane")!, description: String(format: "Time %d", indexPath.row))
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
