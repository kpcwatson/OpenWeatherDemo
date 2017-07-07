//
//  CitiesViewController.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
}

extension CitiesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    
}

extension CitiesViewController: UICollectionViewDelegateFlowLayout {
    
}
