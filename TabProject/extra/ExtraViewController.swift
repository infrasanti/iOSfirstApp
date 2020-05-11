//
//  ExtraViewController.swift
//  TabProject
//
//  Created by Santiago Ramirez on 02/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class ExtraViewController: UIViewController {
    
    @IBOutlet var gridSelector: UISegmentedControl!
    
    @IBOutlet var incrementControl: UIStepper!
    
    @IBOutlet var nSideLabel: UILabel!
    
    private var nSide: Int {
        return Int(incrementControl.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incrementControl.stepValue = 1
        incrementControl.minimumValue = 5
        incrementControl.maximumValue = 20
        incrementControl.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        nSideLabel.text = "\(nSide)"
        // Do any additional setup after loading the view.
    }
    
    @objc func stepperChanged() {
        nSideLabel.text = "\(nSide)"
    }
    
    @IBAction func startGame(_ sender: Any) {
        let gameController = GameController()
        if (gridSelector.selectedSegmentIndex == 0) {
            gameController.grid = SquareGrid(nSide: nSide)
        } else {
            gameController.grid = HexagonalGrid(nSide: nSide)
        }
        self.present(gameController, animated: true)
    }
    
}
