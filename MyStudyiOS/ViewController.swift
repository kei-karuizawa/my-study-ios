//
//  ViewController.swift
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/20.
//

import UIKit
import KirihaCodeKit

class ViewController: UIViewController {
    
    private let timeHelper = KCKTimerHelper(timeInterval: 4)
    static let bigjpgTimerProcessKey = "BigjpgService.bigjpgTimerProcessKey"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        self.timeHelper.addTimer(for: { [weak self] in
            print("1111")
        }, key: ViewController.bigjpgTimerProcessKey)
    }
}

