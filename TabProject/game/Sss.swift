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
    func paths(with width: CGFloat, with height: CGFloat) -> [CGPath]
    //TODO remove this method
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
    
    //TODO remove
    func paths( with width: CGFloat, with height: CGFloat) -> [CGPath] {
        var paths = [CGPath]()
        for i in 0..<size {
            paths.append(path(for: i, with: width, with: height))
        }
        return paths
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
            print("!!! cell selected")

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
            view.drawSolution(sequence: path)
            grid[finalPosition] = grid.selectedValue!
            grid[initPosition] = 0
            grid.selectedCell = nil
            return true
        } else {
            //TODO show impossible path
            print("!!! not path found")
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



class DummyPathFinder: PathFinder {
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]? {
        return [Int]()
    }
}

