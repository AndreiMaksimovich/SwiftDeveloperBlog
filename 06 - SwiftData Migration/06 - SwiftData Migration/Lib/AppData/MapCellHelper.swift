//
//  MapCellHelper.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 22/04/2026.
//

nonisolated struct MapCellHelper {
    
    private let earthP: Double = 40_075_000 // equator
    let cellSize: Double
    let cellSizeDegres: Double

    
    init(cellSize: Double) {
        self.cellSize = cellSize
        self.cellSizeDegres = 360 * cellSize / earthP
    }
    
    func cell(longitude: Double, lattitude: Double) -> Int64 {
        let lon = longitude + 180
        let lat = (lattitude + 90) * 2
        
        
        let cellX = Int64(lon / cellSizeDegres)
        let cellY = Int64(lat / cellSizeDegres)
        
        return cellX * Int64(Int32.max) + cellY
    }
    
    func location(cell: Int64) -> (Double, Double) {
        let cellX: Int64 = cell / Int64(Int32.max)
        let cellY: Int64 = cell % Int64(Int32.max)
        
        return (
            Double(cellX) * cellSizeDegres - 180,
            Double(cellY) * cellSizeDegres / 2.0 - 90,
        )
    }
}
