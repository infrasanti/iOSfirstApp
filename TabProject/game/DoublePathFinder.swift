//
//  DoublePathFinder.swift
//  TabProject
//
//  Created by Santiago Ramirez on 10/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation

class SinglePathFinder : PathFinder {
    
    var bestPaths = [Int: Path]()
    var lastAddedPaths = [Path]()
    
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]? {
        if (grid.getCellValue(at: to) != 0) {
            return nil
        }
        
        //INIT
        let initPath = Path(sequence: [from])
        bestPaths.removeAll()
        lastAddedPaths.removeAll()
        bestPaths[initPath.end] = initPath
        lastAddedPaths.append(initPath)
        
        let maxIteration = grid.size
        
        for _ in 1...maxIteration {
            let (finish, solution) = iteration(grid: grid, target: to)
            if (finish) {
                return solution?.sequence
            }
        }
        
        return nil
        
        
    }
    
    func iteration(grid: Grid, target: Int) -> (Bool, Path?) {
        
        //Check no solution end case
        if (lastAddedPaths.isEmpty) {
            return (true, nil)
        }
        
        //If no stop condition, lets fork and reduce
        var newAddedPaths = [Path]()
        for lastAddedPath in lastAddedPaths {
            for neighbourCell in grid.getNeighbours(of: lastAddedPath.end) {
                if (neighbourCell == target) {
                    //Check if new portential path is solution
                    return (true, lastAddedPath.fork(to: target))
                }
                
                if (grid[neighbourCell] == 0) {
                    let forkedPath = lastAddedPath.fork(to: neighbourCell)
                    if let bestPath = bestPaths[forkedPath.end] {
                        if (forkedPath.distance < bestPath.distance) {
                            bestPaths[forkedPath.end] = forkedPath
                        }
                        
                    } else {
                        bestPaths[forkedPath.end] = forkedPath
                        newAddedPaths.append(forkedPath)
                    }
                    
                }
            }
        }
        
        lastAddedPaths.removeAll()
        lastAddedPaths.append(contentsOf: newAddedPaths)
        
        return (false, nil)
        
    }


}

class Path {
    
    let sequence: [Int]
    
    var end: Int {
        return sequence.last!
    }
    
    var distance: Int {
        return sequence.count
    }
    
    init(sequence: [Int]) {
        if sequence.isEmpty {
            fatalError("Empty sequence")
        }
        
        self.sequence = sequence

    }
    
    func fork(to neigbour: Int) -> Path {
        var newSequence = [Int]()
        newSequence.append(contentsOf: sequence)
        newSequence.append(neigbour)
        return Path(sequence: newSequence)
    }
    
    enum VendingMachineError: Error {
        case invalidSelection
        case insufficientFunds(coinsNeeded: Int)
        case outOfStock
    }
}
