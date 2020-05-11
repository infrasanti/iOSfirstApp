//
//  GameController.swift
//  TabProject
//
//  Created by Santiago Ramirez on 11/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit
import Foundation

class GameController: UIViewController, GameView {
 
    @IBOutlet var nextColorsStackView: UIStackView!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var boardView: GameBoardView!
    
    var grid: Grid? = nil
    private var game: Game? = nil
    
    var points: Int = 0 {
        didSet {
            pointsLabel.text = "\(points)"
        }
    }
    
    var nextColors: [Int] = [] {
        didSet {
            if nextColorsStackView.arrangedSubviews.count != nextColors.count {
                for view in nextColorsStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                
                for _ in nextColors {
                    let newView = UIView()
                    newView.translatesAutoresizingMaskIntoConstraints = false

                    let widthConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 32)
                    let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 32)
                    
                    newView.layer.cornerRadius = 16

                    nextColorsStackView.addArrangedSubview(newView)
                    nextColorsStackView.addConstraints([widthConstraint, heightConstraint])

                }
            }
            
            var index = 0
            for view in nextColorsStackView.arrangedSubviews {
                view.backgroundColor = UIColor(cgColor: GameBoardView.colors[nextColors[index]])
                index += 1
            }
        }
    }
    
    var listener: ((Int) -> Void)?
    
    func draw(cellMovePath: [Int]) {
        boardView.drawSolution(sequence: cellMovePath)
    }
    
    func draw() {
        boardView.setNeedsDisplay()
    }
    
    func showGameOver() {
        let alert = UIAlertController(title: "Game Over", message: "You get a score of \(points) points", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Finish", style: UIAlertAction.Style.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        boardView.listener = onUserClick(clickCell:)
        if let grid = grid {
            boardView.grid = grid
            game = Game(grid: grid, view: self, pathFinder: DoublePathFinder())
            game?.start()
        }
    }
    
    private func onUserClick(clickCell: Int) {
        listener?(clickCell)
    }
}
