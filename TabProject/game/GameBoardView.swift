//
//  GameBoardView.swift
//  TabProject
//
//  Created by Santiago Ramirez on 07/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    
    private let colors = [UIColor.white.cgColor, UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.green.cgColor, UIColor.cyan.cgColor , UIColor.magenta.cgColor, UIColor.yellow.cgColor, UIColor.gray.cgColor]
    
    
    var listener: ((Int) -> Void)?
    
    var grid: Grid?
    
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
                cellPaths = [CGPath]()
                for cell in 0..<grid.size {
                    cellPaths?.append(grid.path(for: cell, with: rect.width, with: rect.height))
                }
            }
            
            ctx.setFillColor(UIColor.black.cgColor)
            ctx.setLineWidth(2)
            
            for cell in 0..<grid.size {
                ctx.setFillColor(colors[grid[cell]])
                ctx.addPath(cellPaths![cell])
                ctx.drawPath(using: CGPathDrawingMode.fillStroke)
            }
        }
    }
}
