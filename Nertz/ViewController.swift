//
//  ViewController.swift
//  Nertz
//
//  Created by Maya McAuliffe on 8/16/18.
//  Copyright © 2018 Maya McAuliffe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabletop = TabletopController(view: view)
        view.addSubview(tabletop.tabletopView)
    }
    
    

}

