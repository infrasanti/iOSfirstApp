//
//  Sss.swift
//  TabProject
//
//  Created by Santiago Ramirez on 06/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation
import UIKit

protocol Grid {
    var size: Int {get}
    var selectedCell: Int? {get set}
    func getCellValue(at position: Int) -> Int
    func getNeighbours(of position: Int) -> [Int]
    func update(cell: Int, value: Int)
    func lines(for position: Int) -> [[Int]]
    func path(for cellIndex: Int, with width: CGFloat, with height: CGFloat) -> CGPath
}

extension Grid {
    var selectedValue: Int? {
        if let selectedPosition = selectedCell {
            return getCellValue(at: selectedPosition)
        } else {
            return nil
        }
    }
    
    subscript(index: Int) -> Int {
        get {
            return getCellValue(at: index)
        }
        set {
            update(cell: index, value: newValue)
        }
    }
}

protocol PathFinder {
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]?
}

class Game {
    var grid: Grid
    var view: GameBoardView
    let pathFinder: PathFinder
    let nColors, nNewItems, nItemsInLineToDelete: Int
    
    var turn = 0
    var nEmptyCells = 0
    var nCellsDeleted = 0
    var points = 0
    var nextCellsValues = [Int]()

    
    init(grid: Grid,
         view: GameBoardView,
         pathFinder: PathFinder,
         nColors: Int = 5,
         nNewItems: Int = 3,
         nItemsInLineToDelete: Int = 5) {
        
        self.grid = grid
        self.view = view
        view.grid = grid
        self.pathFinder = pathFinder
        self.nColors = nColors
        self.nNewItems = nNewItems
        self.nItemsInLineToDelete = nItemsInLineToDelete
        nEmptyCells = grid.size
    }
    
    func start() {
        view.listener = onUserClick(clickedCell:)
        nextCellsValues = generateNextCellValues()
        nextTurn()
    }
    
    func nextTurn() {
        turn += 1
        nextCellsValues.forEach { (value) in
            if (!tryToAddRandomCell(with: value)) {
                gameOver()
                return
            }
        }
        nextCellsValues = generateNextCellValues()
        draw()
    }
    
    func gameOver() {
        //TODO
    }
    
    func generateNextCellValues() -> [Int] {
        var newCellsValues = [Int]()
        for _ in 0..<nNewItems {
            newCellsValues.append(Int.random(in: 1...nColors))
        }
        return newCellsValues
    }
    
    func tryToAddRandomCell(with value: Int) -> Bool {
        if nEmptyCells > 0 {
            let pickIndex = (0..<nEmptyCells).randomElement()
            var emptyCellCount = 0
            for i in 0..<grid.size {
                if (grid[i] == 0) {
                    if (emptyCellCount == pickIndex) {
                        grid[i] = value
                        nEmptyCells -= 1
                        return true
                    } else {
                        emptyCellCount += 1
                    }
                }
            }
        }
        
        return false
    }

    func onUserClick(clickedCell: Int) {
            
        if (grid[clickedCell] != 0) {
            //If a non empty cell clicked, lets select it
            grid.selectedCell = clickedCell
        } else {
            if let selectedPostion = grid.selectedCell {
                if (tryToMove(from: selectedPostion, to: clickedCell)) {
                    let itemsToDelete = computeCellsToDelete(for: clickedCell)
                    let nItemsDeleted = itemsToDelete.count
                    if (!itemsToDelete.isEmpty) {
                        //TODO animate deletion.
                        nCellsDeleted += nItemsDeleted
                        nEmptyCells += nItemsDeleted
                        points += nItemsDeleted * (nItemsDeleted - nItemsInLineToDelete + 1)
                        itemsToDelete.forEach { (item) in
                            grid[item] = 0
                        }
                    }
                    nextTurn()
                        
                }
            }
        }
            
        draw()
        
    }
    
    private func tryToMove(from initPosition: Int, to finalPosition: Int) -> Bool {
        if let path = pathFinder.computePath(grid: grid, from: initPosition, to: finalPosition) {
            //TODO anim cell using path
            grid[finalPosition] = grid.selectedValue!
            grid[initPosition] = 0
            grid.selectedCell = nil
            return true
        } else {
            //TODO show impossible path
            return false
        }
    }
    
    private func computeCellsToDelete(for position: Int) -> [Int] {
        let value = grid[position]
        var cellsToDelete = Set<Int>()
        let lines = grid.lines(for: position)
        for line in lines {
            let index = line.firstIndex(of: position)!
            var cellsToDeleteInLine = [Int]()
            cellsToDeleteInLine.append(position)
            var i = index + 1
            while i < line.count {
                let cell = line[i]
                if (grid[cell] == value) {
                    cellsToDeleteInLine.append(cell)
                    i += 1
                } else {
                    break
                }
            }
            i = index - 1
            while i >= 0 {
                let cell = line[i]
                if (grid[cell] == value) {
                    cellsToDeleteInLine.append(cell)
                    i -= 1
                } else {
                    break
                }
            }
            if (cellsToDeleteInLine.count >= nItemsInLineToDelete) {
                cellsToDeleteInLine.forEach { (cell) in
                    cellsToDelete.insert(cell)
                }
            }
        }
        
        return Array(cellsToDelete)
        
    }
    
    
    func draw() {
        view.setNeedsDisplay()
    }
}

class SquareGrid: Grid {
    
    let nSide: Int
    var cells: [[Int]]
    
    init(nSide: Int) {
        self.nSide = nSide
        self.size = nSide * nSide
        self.cells = Array(repeating: Array(repeating: 0, count: nSide), count: nSide)
    }
    
    var size: Int
    
    var selectedCell: Int?
    
    func getCellValue(at position: Int) -> Int {
        let (x,y) = transform(position)
        return cells[x][y]
    }
    
    func getNeighbours(of position: Int) -> [Int] {
        let (x,y) = transform(position)
        var neighbours = [Int]()
        if (x > 0) {
            neighbours.append(transform((x - 1, y)))
        }
        
        if (x < nSide - 1) {
            neighbours.append(transform((x + 1, y)))
        }
        
        if (y > 0) {
            neighbours.append(transform((x, y - 1)))
        }
        
        if (y < nSide - 1) {
            neighbours.append(transform((x, y + 1)))
        }

        return neighbours
    }
    
    func update(cell: Int, value: Int) {
        let (x,y) = transform(cell)
        cells[x][y] = value
    }
    
    func lines(for position: Int) -> [[Int]] {
        let (x,y) = transform(position)
        var lines = [[Int]]()
        var lineH = [Int]()
        var lineV = [Int]()
        var lineDa = [Int]()
        var lineDb = [Int]()

        for i in 0..<nSide {
            lineH.append(transform((x, i)))
            lineV.append(transform((i, y)))
        }
        
        var xDa = 0
        var yDa = 0
        if (x > y) {
            xDa = x - y
        } else {
            yDa = y - x
        }
        
        while(xDa < nSide && yDa < nSide) {
            lineDa.append(transform((xDa, yDa)))
            xDa += 1
            yDa += 1
        }
        
        var xDb = 0
        var yDb = nSide - 1
        if (x + y > nSide - 1) {
            xDb = (x + y) - nSide + 1
        } else {
            yDb = x + y
        }
        
        while(xDb < nSide && yDb >= 0) {
            lineDb.append(transform((xDb, yDb)))
            xDb += 1
            yDb -= 1
        }
        
        lines.append(lineH)
        lines.append(lineV)
        lines.append(lineDa)
        lines.append(lineDb)
        return lines
    }
    
    func path(for cellIndex: Int, with width: CGFloat, with height: CGFloat) -> CGPath {
        let (x,y) = transform(cellIndex)
        let wCell = CGFloat(width) / CGFloat(nSide)
        let hCell = CGFloat(height) / CGFloat(nSide)

        let xCell = wCell * CGFloat(x)
        let yCell = hCell * CGFloat(y)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: xCell, y: yCell))
        path.addLine(to: CGPoint(x: xCell + wCell, y: yCell))
        path.addLine(to: CGPoint(x: xCell + wCell, y: yCell + wCell))
        path.addLine(to: CGPoint(x: xCell, y: yCell + wCell))
        path.closeSubpath()
        return path
    }
    
    private func transform(_ position: Int) -> (Int, Int) {
        let y: Int = position / nSide
        let x = position - y * nSide
        return (x, y)
    }
    
    private func transform(_ coordinates: (Int, Int)) -> Int {
        return coordinates.1 * nSide + coordinates.0
    }
}

class DummyPathFinder: PathFinder {
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]? {
        return [Int]()
    }
}

