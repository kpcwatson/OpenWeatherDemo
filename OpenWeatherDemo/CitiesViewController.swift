//
//  CitiesViewController.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

let citiesKey = "CitiesKey"

// FIXME: better error handling when recoverable

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentConditionsForCity = [String: CurrentCondition]()
    var sortedCityKeys: [String] {
        return self.currentConditionsForCity.keys.sorted()
    }
    
    private let defaults = UserDefaults.standard
    private var weatherService: WeatherService!
    
    fileprivate var selectedIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weatherService = WeatherService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let cities = defaults.array(forKey: citiesKey) as? [String] {
            weatherService.currentForecasts(inEach: cities, onForecastUpdated: { [weak self] (city, condition, error) in
                guard error == nil else {
                    Logger.error("error fetching forecast: \(error!)")
                    return
                }
                
                self?.currentConditionsForCity[city] = condition
            }, onComplete: { [weak self] in
                self?.collectionView.reloadData()
            })
        }
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

extension CitiesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentConditionsForCity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath)
        guard let cityCell = cell as? CityCell else {
            fatalError("Expected CityCell")
        }
        
        guard let city = cityForIndexPath(indexPath) else {
            fatalError("indexPath out of bounds")
        }
        cityCell.representedModel = BriefCityCondition(condition: currentConditionsForCity[city])
        
//        cityCell.widthAnchor
//            .constraint(equalTo: collectionView.widthAnchor, multiplier: 0)
//            .isActive = true
        return cityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CitiesFooter", for: indexPath)
    }

}

extension CitiesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "ShowForecastDetails", sender: self)
    }
}
