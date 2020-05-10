//
//  GameViewController.swift
//  TabProject
//
//  Created by Santiago Ramirez on 07/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameView: GameBoardView!
    
    private var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game(grid: HexagonalGrid(nSide: 6), view: gameView, pathFinder: SinglePathFinder())
        game?.start()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
