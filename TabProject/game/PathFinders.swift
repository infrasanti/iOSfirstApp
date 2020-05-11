//
//  DoublePathFinder.swift
//  TabProject
//
//  Created by Santiago Ramirez on 10/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation

class DummyPathFinder: PathFinder {
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]? {
        return [Int]()
    }
}

class SinglePathFinder : PathFinder {
    
    var bestPaths = [Int: Path]()
    var lastAddedPaths = [Path]()
    
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]? {
        if (grid.getCellValue(for: to) != 0) {
            return nil
        }
        
        //INIT
        initialization(from: from)
        
        let maxIteration = grid.size
        
        for _ in 1...maxIteration {
            let (finish, solution) = iteration(grid: grid, target: to)
            if (finish) {
                return solution?.sequence
            }
        }
        
        return nil
    }
    
    func initialization(from: Int) {
        let initPath = Path(sequence: [from])
        bestPaths.removeAll()
        lastAddedPaths.removeAll()
        bestPaths[initPath.end] = initPath
        lastAddedPaths.append(initPath)
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

class DoublePathFinder: PathFinder {
    
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]? {
        let pathFinderInit = SinglePathFinder()
        let pathFinderEnd = SinglePathFinder()
        pathFinderInit.initialization(from: from)
        pathFinderEnd.initialization(from: to)
        
        let maxIteration = grid.size
        
        for _ in 1...maxIteration {
            let (finishInit, solutionInit) = pathFinderInit.iteration(grid: grid, target: to)
            if (finishInit) {
                return solutionInit?.sequence
            }
            
            if let mergedSolution = checkMergePaths(initPaths: pathFinderInit.lastAddedPaths, endPaths: pathFinderEnd.lastAddedPaths) {
                return mergedSolution
            }
            
            let (finishEnd, solutionEnd) = pathFinderEnd.iteration(grid: grid, target: from)
            if (finishEnd) {
                return solutionEnd?.sequence
            }
            
            if let mergedSolution = checkMergePaths(initPaths: pathFinderInit.lastAddedPaths, endPaths: pathFinderEnd.lastAddedPaths) {
                return mergedSolution
            }
        }
        
        return nil

    }
    
    private func checkMergePaths(initPaths: [Path], endPaths: [Path]) -> [Int]? {
        for initPath in initPaths {
            for endPath in endPaths {
                if (initPath.end == endPath.end) {
                    var solution = [Int]()
                    solution.append(contentsOf: initPath.sequence)
                    solution.append(contentsOf: endPath.sequence.reversed().dropFirst())
                    return solution
                }
            }
        }
        return nil
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
