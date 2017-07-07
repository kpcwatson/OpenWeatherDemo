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
    
    fileprivate let store = CitiesPersistentStore()
    fileprivate var weatherService: WeatherService!
    
    fileprivate var selectedIndexPath: IndexPath?
    
    fileprivate var sortedCities: [String] {
        return store.allCities.sorted()
    }
    
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
        
        tableView.beginUpdates()
        var inserts = [IndexPath]()
        weatherService.currentForecasts(inEach: sortedCities, onForecastUpdated: { [weak self] (city, condition, error) in
            guard error == nil else {
                Logger.error("error fetching forecast: \(error!)")
                return
            }
            
            guard let indexPath = self?.indexPath(for: city) else {
                self?.currentConditionsForCity[city] = condition
                self?.tableView.reloadData()
                return
            }
            
            if self?.currentConditionsForCity.keys.contains(city) == false {
                inserts.append(indexPath)
            }

            self?.currentConditionsForCity[city] = condition
        }, onComplete: { [weak self] in
            self?.tableView.insertRows(at: inserts, with: .automatic)
            self?.tableView.endUpdates()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let detailsViewController = segue.destination as? CityDetailsViewController {
            guard let selectedIndexPath = selectedIndexPath,
                let city = city(for: selectedIndexPath),
                let conditions = currentConditionsForCity[city]
                else {
                    fatalError("required info is missing for presenting details view controller")
            }
            
            detailsViewController.city = city
            detailsViewController.currentConditions = conditions
            
        } else if let addCityViewController = segue.destination as? AddCityViewController {
            addCityViewController.delegate = self
        }
    }
    
    fileprivate func city(for indexPath: IndexPath) -> String? {
        guard sortedCities.count > indexPath.item else {
            return nil
        }
        return sortedCities[indexPath.item]
    }
    
    fileprivate func indexPath(for city: String) -> IndexPath? {
        guard let index = sortedCities.index(of: city) else {
            return nil
        }
        return IndexPath(row: index, section: 0)
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
        
        guard let city = city(for: indexPath) else {
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
            let city = city(for: indexPath) {
            
            store.remove(city: city)
            currentConditionsForCity.removeValue(forKey: city)
            tableView.reloadData()
        }
    }
}

extension CitiesViewController: AddCityViewControllerDelegate {
    
    func addCityViewController(_ viewController: AddCityViewController, didAdd city: String) {
        Logger.debug("added \(city)")
        store.add(city: city)
    }
}
