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
    
    @IBOutlet var detailsView: CityDetailsView!
    
    var city: String!
    var currentConditions: CurrentCondition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = city
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let conditionDetails = CityConditionDetails(condition: currentConditions)
        detailsView.representedModel = conditionDetails
    }
}
