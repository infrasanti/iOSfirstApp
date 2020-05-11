//
//  Grids.swift
//  TabProject
//
//  Created by Santiago Ramirez on 10/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation
import UIKit

class SquareGrid: Grid {
    
    let nSide: Int
    private var cells: [[Int]]
    
    init(nSide: Int) {
        self.nSide = nSide
        self.size = nSide * nSide
        self.cells = Array(repeating: Array(repeating: 0, count: nSide), count: nSide)
    }
    
    var size: Int
    
    var selectedCell: Int?
    
    func getCellValue(for position: Int) -> Int {
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
    
    func update(cellIndex: Int, value: Int) {
        let (x,y) = transform(cellIndex)
        cells[x][y] = value
    }
    
    func lines(withCenter cellIndex: Int) -> [[Int]] {
        let (x,y) = transform(cellIndex)
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
    
    func paths(with width: CGFloat, with height: CGFloat) -> [CGPath] {
        var paths = [CGPath]()
        let wCell = CGFloat(width) / CGFloat(nSide)
        let hCell = CGFloat(height) / CGFloat(nSide)

        for cell in 0..<size {
            let (x,y) = transform(cell)
            let xCell = wCell * CGFloat(x)
            let yCell = hCell * CGFloat(y)
            let path = CGMutablePath()
            path.move(to: CGPoint(x: xCell, y: yCell))
            path.addLine(to: CGPoint(x: xCell + wCell, y: yCell))
            path.addLine(to: CGPoint(x: xCell + wCell, y: yCell + wCell))
            path.addLine(to: CGPoint(x: xCell, y: yCell + wCell))
            path.closeSubpath()
            paths.append(path)
        }
        return paths
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

class HexagonalGrid : Grid {
    
    private let nSide: Int
    private let internalGridSide: Int

    var size: Int
    
    var selectedCell: Int?
    
    private var cells: [[Int]]
    private var indexMap = [(Int, Int)]()
    
    private let neighboursShifts = [(1,0), (1, 1), (0, 1), (-1, 0), (-1, -1), (0, -1)]
    
    private let linesShifts = [(1,0), (1, 1), (0, 1),]
    
    private let unityVectorX: (CGFloat, CGFloat)
    private let unityVectorY: (CGFloat, CGFloat)



    init(nSide: Int) {
        self.nSide = nSide
        self.size = 3 * nSide * nSide - 3 * nSide + 1
        self.internalGridSide = 2 * nSide - 1
        self.unityVectorX = (1, 0)
        let angle = CGFloat.pi * 2 / 3
        self.unityVectorY = (cos(angle), sin(angle))
        
        
        self.cells = Array(repeating: Array(repeating: 0, count: internalGridSide), count: internalGridSide)
        for i in 0..<internalGridSide {
            for j in 0..<internalGridSide {
                if (areInBounds(coordinates: (i, j))) {
                    indexMap.append((i, j))
                }
            }
        }
        
        if indexMap.count != size {
            fatalError("Cell size not correct")
        }
    }
    
    func getCellValue(for cellIndex: Int) -> Int {
        let (x,y) = transform(cellIndex)
        return cells[x][y]
    }
    
    func getNeighbours(of cellIndex: Int) -> [Int] {
        let (x,y) = transform(cellIndex)
        var neighbours = [Int]()
        
        neighboursShifts.forEach { (sift) in
            let point = (x + sift.0, y + sift.1)
            if (areInBounds(coordinates: point)) {
                neighbours.append(transform(point))
            }
        }

        return neighbours
    }
    
    func update(cellIndex: Int, value: Int) {
        let (x,y) = transform(cellIndex)
        cells[x][y] = value
    }
    
    func lines(withCenter cellIndex: Int) -> [[Int]] {
        let (x,y) = transform(cellIndex)
        var lines = [[Int]]()
        for lineShift in linesShifts {
            var line = [Int]()
            var lineX = x
            var lineY = y
            var nextX = x
            var nextY = y
            
            while areInBounds(coordinates: (nextX, nextY)) {
                lineX = nextX
                lineY = nextY
                nextX += lineShift.0
                nextY += lineShift.1
            }
            
            nextX = lineX
            nextY = lineY
            
            while areInBounds(coordinates: (nextX, nextY)) {
                line.append(transform((nextX, nextY)))
                nextX -= lineShift.0
                nextY -= lineShift.1
            }
            
            lines.append(line)
        }
        return lines
    }
    
    func paths(with width: CGFloat, with height: CGFloat) -> [CGPath] {
        let cellDistance: CGFloat = width / CGFloat(2 * nSide - 1)
        let cellAphotem: CGFloat = cellDistance / 2
        let cellR: CGFloat = cellAphotem / sin(CGFloat.pi / 3)
        
        var hexagonPointShifts = [(CGFloat, CGFloat)]()
        let angleStep = CGFloat.pi / 3
        var angle: CGFloat = CGFloat.pi / 6
        for _ in 1...6 {
            hexagonPointShifts.append((cellR * cos(angle), cellR * sin(angle)))
            angle += angleStep
        }
        
        
        let offsetX = CGFloat(nSide - 1) * cellDistance / 2 + cellAphotem
        let offsetY = cellR
        
        var paths = [CGPath]()
        for coordinates in indexMap {
            
            var centerX: CGFloat = (CGFloat(coordinates.0) * unityVectorX.0 + CGFloat(coordinates.1) * unityVectorY.0)
     

            var centerY: CGFloat = (CGFloat(coordinates.0) * unityVectorX.1 + CGFloat(coordinates.1) * unityVectorY.1)
            
            centerX = centerX * cellDistance + offsetX
            centerY = centerY * cellDistance + offsetY

            let path = CGMutablePath()
            path.move(to: CGPoint(x: centerX + hexagonPointShifts.first!.0, y: centerY + hexagonPointShifts.first!.1))
            for i in 1..<6 {
                path.addLine(to: CGPoint(x: centerX + hexagonPointShifts[i].0, y: centerY + hexagonPointShifts[i].1))
            }
            
            path.closeSubpath()
            
            paths.append(path)
        }
        
        return paths
    }
    
    private func areInBounds(coordinates: (Int, Int)) -> Bool {
        switch coordinates {
        case let (x, y) where x < 0 || y < 0 || x >= internalGridSide || y >= internalGridSide:
            return false
        case let (x, y) where y > x + nSide - 1 :
            return false
        case let (x, y) where y < x - nSide + 1 :
            return false
        default:
            return true
        }
    }
    
    private func transform(_ position: Int) -> (Int, Int) {
        return indexMap[position]
    }
    
    private func transform(_ coordinates: (Int, Int)) -> Int {
        return indexMap.firstIndex { (mapCoordinates) -> Bool in
            mapCoordinates == coordinates
        } ?? -1
    }
}
