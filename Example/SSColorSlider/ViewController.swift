//
//  ViewController.swift
//  SSColorSlider
//
//  Created by swetasheth29 on 11/08/2022.
//  Copyright (c) 2022 swetasheth29. All rights reserved.
//

import UIKit
import SSColorSlider

class ViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorSlider: SSColorSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorSlider.addTarget(self, action: #selector(sliderChanged(slider:event:)), for: .valueChanged)
        self.colorView.backgroundColor = self.colorSlider.color
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func sliderChanged(slider: SSColorSlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            print(touchEvent.phase, slider.color, slider.value)
            
            self.colorView.backgroundColor = slider.color
        }
    }
}

