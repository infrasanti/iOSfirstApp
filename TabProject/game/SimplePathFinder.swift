//
//  SimplePathFinder.swift
//  TabProject
//
//  Created by Santiago Ramirez on 07/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation

class SantiPathFinder: PathFinder {
    
    
    func computePath(grid: Grid, from: Int, to: Int) -> [Int]? {
        //INIT
        let maxIterations = grid.size * grid.size
        var paths = [Path(path: [from])]
        var lastAddedPaths = [Path(path: [from])]
        
        
        for _ in 1...maxIterations {
        
            //ITERATION

            //fork paths
            var newPaths = [Path]()
            lastAddedPaths.forEach { (path) in
                let neighbours = grid.getNeighbours(of: path.end).filter { (value) -> Bool in
                    value == 0
                }
                
                if (!neighbours.isEmpty) {
                    newPaths.append(contentsOf: path.fork(into: neighbours))
                }
            
            }
            
            if let solution = newPaths.first(where: { (path) -> Bool in
                path.end == to
            }) {
                return solution.path
            }
            
            //reduce paths
            newPaths = reduce(newPaths)
            var pathsToAdd = [Path]()

            newPaths.forEach { (path) in
                if let sameEndPath = paths.first(where: { (existingPath) -> Bool in
                    existingPath.end == path.end}) {
                    if (sameEndPath.path.count > path.path.count) {
                        paths.remove(at: paths.firstIndex(of: sameEndPath)!)
                        pathsToAdd.append(path)
                    }
                    
                } else {
                    pathsToAdd.append(path)
                }
            }
            
            if (pathsToAdd.isEmpty) {
                return nil
            } else {
                paths.append(contentsOf: pathsToAdd)
                lastAddedPaths.removeAll()
                lastAddedPaths.append(contentsOf: pathsToAdd)
            }
        }
        
        return nil
        
    }
    
    private func reduce(_ paths: [Path]) -> [Path] {
        //TODO        
        return paths
    }
    
    class Path: Equatable {
        static func == (lhs: SantiPathFinder.Path, rhs: SantiPathFinder.Path) -> Bool {
            return lhs.path == rhs.path
        }
        
        let path: [Int]
        let end: Int
        var forked = false

        init(path: [Int]) {
            self.path = path
            self.end = path.last!
        }
        
        func fork(into neighbours: [Int]) -> [Path] {
            forked = true
            var forkedPaths = [Path]()
            
            neighbours.forEach { (neighbour) in
                var newPath = [Int]()
                newPath.append(contentsOf: self.path)
                newPath.append(neighbour)
                forkedPaths.append(Path(path: newPath))
            }
            
            return forkedPaths
        }
    }
}
