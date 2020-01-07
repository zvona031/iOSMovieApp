//
//  TabBarController.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 04/01/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItems()
    }
    
    func setTabBarItems(){
        let tabBarItem0 = (self.tabBar.items?[0])! as UITabBarItem
        tabBarItem0.title = "Latest"
        tabBarItem0.image = UIImage(named: "film-roll")
        
        
        let tabBarItem1 = (self.tabBar.items?[1])! as UITabBarItem
        tabBarItem1.title = "Popular"
        tabBarItem1.image = UIImage(named: "flame")

        
        let tabBarItem2 = (self.tabBar.items?[2])! as UITabBarItem
        tabBarItem2.title = "Favorite"
        tabBarItem2.image = UIImage(named: "favorite")
        
        let tabBarItem3 = (self.tabBar.items?[3])! as UITabBarItem
        tabBarItem3.title = "Search"
        tabBarItem3.image = UIImage(named: "search")
    }
}
