//
//  GameBoardView.swift
//  TabProject
//
//  Created by Santiago Ramirez on 07/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    
    public static let colors = [UIColor.white.cgColor, UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.green.cgColor, UIColor.orange.cgColor , UIColor.magenta.cgColor, UIColor.yellow.cgColor, UIColor.gray.cgColor]
    
    var listener: ((Int) -> Void)?
    
    var grid: Grid?
    
    private var path: CGPath?
    
    private var cellPaths: [CGPath]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAction(_:))))
    }
    
    func drawSolution(sequence: [Int]) {
        if (sequence.count <= 1) {
            return
        }
        if let cellPaths = cellPaths {
            let path = CGMutablePath()
            let cellPath = cellPaths[sequence.first!]
            path.move(to: cellPath.center())
            
            for i in 1..<sequence.count {
                path.addLine(to: cellPaths[sequence[i]].center())
            }
            
            self.path = path
        }
        
    }
    
    @objc func clickAction(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if let paths = cellPaths {
            for i in paths.indices {
                if paths[i].contains(location) {
                    listener?(i)
                    return
                }
            }
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let grid = grid, let ctx = UIGraphicsGetCurrentContext() {
            if cellPaths == nil {
                cellPaths = grid.paths(with: rect.width, with: rect.height)
            }
            
            ctx.setLineWidth(2)
            
            for cell in 0..<grid.size {
                ctx.setFillColor(GameBoardView.colors[grid[cell]])
                ctx.addPath(cellPaths![cell])
                ctx.drawPath(using: CGPathDrawingMode.fillStroke)
            }
            
            if let selectedCell = grid.selectedCell {
                ctx.setLineWidth(5)
                ctx.addPath(cellPaths![selectedCell])
                ctx.drawPath(using: CGPathDrawingMode.stroke)
            }
            
            if let path = path {
                ctx.setLineWidth(2)
                ctx.setFillColor(UIColor.black.cgColor)
                ctx.addPath(path)
                ctx.drawPath(using: CGPathDrawingMode.stroke)
            }
        }
    }
}

extension CGPath {
    func  center() -> CGPoint {
        return CGPoint(x: self.boundingBox.midX, y: self.boundingBox.midY)
    }
}
