//
//  navi.swift
//  qusaiapp
//
//  Created by Admin on 2/19/17.
//  Copyright © 2017 Mfortis. All rights reserved.
//

import UIKit

class navi: UINavigationController , UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.default
        self.navigationBar.tintColor = UIColor.blue
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }

}
