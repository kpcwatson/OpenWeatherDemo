//
//  CityDetailsViewController.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

class CityDetailsViewController: UIViewController {
    
    var city: String!
    var currentConditions: CurrentCondition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = city
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
