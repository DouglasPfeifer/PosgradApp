//
//  MainTabBarViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 16/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[0].title = "Dashboard"
        tabBar.items?[1].title = "Self-service"
        tabBar.items?[2].title = "News"
        tabBar.items?[3].title = "Times"
        tabBar.items?[4].title = "Game"
        
        tabBar.items?[0].image = resizeImage(image: UIImage(named: "dashboard")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[1].image = resizeImage(image: UIImage(named: "self-service")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[2].image = resizeImage(image: UIImage(named: "break-news")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[3].image = resizeImage(image: UIImage(named: "times")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[4].image = resizeImage(image: UIImage(named: "game")!, targetSize: CGSize(width: 30, height: 30))
        
        tabBar.items?[0].selectedImage = resizeImage(image: UIImage(named: "dashboard_inv")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[1].selectedImage = resizeImage(image: UIImage(named: "self-service_inv")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[2].selectedImage = resizeImage(image: UIImage(named: "break-news_inv")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[3].selectedImage = resizeImage(image: UIImage(named: "times_inv")!, targetSize: CGSize(width: 30, height: 30))
        tabBar.items?[4].selectedImage = resizeImage(image: UIImage(named: "game")!, targetSize: CGSize(width: 30, height: 30))

        self.tabBar.unselectedItemTintColor = UIColor(white: 0.3, alpha: 1.0)
        self.tabBar.tintColor = UIColor(white: 0.1, alpha: 1.0)
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
