//
//  ExtraViewController.swift
//  TabProject
//
//  Created by Santiago Ramirez on 02/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class ExtraViewController: UIViewController {

    @IBOutlet var animationView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func changeY(_ sender: Any) {
        let initX = animationView.frame.origin.x
        let initY = animationView.frame.origin.y
        
        let initW = animationView.frame.width
        let initH = animationView.frame.height
        
        UIView.animate(withDuration: 2.0) {
            self.animationView.frame = CGRect(x: initX, y: initY + 100, width: initW, height: initH)
        }

    }
    
    @IBAction func scaleSmall(_ sender: Any) {
        
        UIView.animate(withDuration: 2.0) {
            self.animationView.transform = self.animationView.transform.scaledBy(x: 0.7, y: 0.7)
        }

    }
    
    @IBAction func scaleBig(_ sender: Any) {
        
        let viewController:UIViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "NavigationGameController") as UIViewController

        self.present(viewController, animated: true, completion: nil)

    }

}
