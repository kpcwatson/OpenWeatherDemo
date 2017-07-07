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

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentConditionsForCity = [String: CurrentCondition]()
    var sortedCityKeys: [String] {
        return self.currentConditionsForCity.keys.sorted()
    }
    
    private let defaults = UserDefaults.standard
    private var weatherService: WeatherService!
    
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
        
        let city = sortedCityKeys[indexPath.item]
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
}
