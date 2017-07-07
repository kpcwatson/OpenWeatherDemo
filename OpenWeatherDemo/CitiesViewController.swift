//
//  CitiesViewController.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

// FIXME: better error handling when recoverable

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentConditionsForCity = [String: CurrentCondition]()
    var sortedCityKeys: [String] {
        return self.currentConditionsForCity.keys.sorted()
    }
    
    fileprivate let store = CitiesPersistentStore()
    fileprivate var weatherService: WeatherService!
    
    fileprivate var selectedIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weatherService = WeatherService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        weatherService.currentForecasts(inEach: store.allCities, onForecastUpdated: { [weak self] (city, condition, error) in
            guard error == nil else {
                Logger.error("error fetching forecast: \(error!)")
                return
            }
            
            self?.currentConditionsForCity[city] = condition
        }, onComplete: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let detailsViewController = segue.destination as? CityDetailsViewController {
            
            guard let selectedIndexPath = selectedIndexPath,
                let city = cityForIndexPath(selectedIndexPath),
                let conditions = currentConditionsForCity[city]
                else {
                    fatalError("required info is missing for presenting details view controller")
            }
            
            detailsViewController.city = city
            detailsViewController.currentConditions = conditions
        }
    }
    
    fileprivate func cityForIndexPath(_ indexPath: IndexPath) -> String? {
        guard sortedCityKeys.count > indexPath.item else {
            return nil
        }
        return sortedCityKeys[indexPath.item]
    }
}

extension CitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "ShowForecastDetails", sender: self)
    }
}

extension CitiesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentConditionsForCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        guard let cityCell = cell as? CityCell else {
            fatalError("Expected CityCell")
        }
        
        guard let city = cityForIndexPath(indexPath) else {
            fatalError("indexPath out of bounds")
        }
        
        cityCell.representedModel = BriefCityCondition(condition: currentConditionsForCity[city])
        
        return cityCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
            let city = cityForIndexPath(indexPath) {
            
            // remove from defaults
            store.remove(city: city)
            currentConditionsForCity.removeValue(forKey: city)
            tableView.reloadData()
        }
    }
}
