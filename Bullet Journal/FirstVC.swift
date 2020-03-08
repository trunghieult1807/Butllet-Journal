//
//  FirstVC.swift
//  Bullet Journal
//
//  Created by Apple on 3/8/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getMonthAndYear()
    }
    
    // MARK: Get time
    func getMonthAndYear() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "LLLL"
        let monthString = dateFormatter.string(from: date)
        timeLabel.text = monthString + ", " + yearString
    }
}
