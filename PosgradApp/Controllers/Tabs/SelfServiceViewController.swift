//
//  SelfServiceViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 18/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class SelfServiceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var selfServiceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selfServiceCollectionView.delegate = self
        selfServiceCollectionView.dataSource = self
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.selfServiceCollectionView.frame.width
        return CGSize(width: (collectionViewWidth/2 - 24), height: (collectionViewWidth/2 - 24))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selfServiceCell", for: indexPath) as! SelfServiceCollectionViewCell
        
        cell.initLabels(image: UIImage(named: "paper-plane")!, description: "Descrição de teste um pouco maior que o normal", type: "PDF")
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
