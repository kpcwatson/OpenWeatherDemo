//
//  HelpViewController.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

class HelpViewController: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        guard let url = Bundle.main.url(forResource: "help", withExtension: "html") else {
            return
        }
        webview.loadRequest(URLRequest(url: url))
    }
}
