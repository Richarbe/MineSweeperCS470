//
//  MineSweeperModel.swift
//  MineSweeper
//
//  Created by AAK on 2/12/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

enum TileType {
    case NumberTile
    case FlagTile
    case CoverTile
    case MineTile
}

struct TileAttributes {
    let row: Int
    let column: Int
    var tiles: [TileType]
}

private var percentageOfMines: UInt32 = 20

class MineSweeperModel: NSObject {

    private var rows = 0
    private var columns = 0
    private var numMines = 0
    
    private var tiles = [[TileAttributes]]()
    
    func startGameWith(rows: Int, columns: Int) -> [[TileAttributes]]{
        self.rows = rows
        self.columns = columns
        
        for row in 0..<rows {
            var tileRow = [TileAttributes]() // Create a one-dimensional array
            for column in 0..<columns {
                tileRow.append(createTile(row: row, column: column)) // Create either a NumberTile or a MineTile.
                tileRow[column].tiles.append(.CoverTile)             // Cover it with a CoverTile.
            }
            tiles.append(tileRow)  // add the one-dimensional array into another array as an element.
        }
        
        print("Number of rows is \(tiles.count)")
        /*
        for i in 0..<rows {
            for j in 0..<columns {
                print(tiles[i][j].row, tiles[i][j].column)
            }
        }
         */
        return tiles
    }
    
    func createTile(row: Int, column: Int) -> TileAttributes {
        let aMine = arc4random_uniform(99) + 1
        if aMine <= percentageOfMines { // how often do we create a mine?
            return TileAttributes(row: row, column: column, tiles: [.MineTile])
        } else {
            return TileAttributes(row: row, column: column, tiles: [.NumberTile])
        }

    }
    
    func actionTiles() -> [[TileAttributes]] {
        return tiles 
    }

}
