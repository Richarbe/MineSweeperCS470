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
    case NoTile
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
    private var numCovered = 0
    private var numFlags = 0
    
    private var tiles = [[TileAttributes]]()
    
    func startGameWith(rows: Int, columns: Int) -> ([[TileAttributes]]){
        self.rows = rows
        self.columns = columns
        
        for row in 0..<rows {
            var tileRow = [TileAttributes]()// Create a one-dimensional array
            for column in 0..<columns {
                tileRow.append(createTile(row: row, column: column)) // Create either a NumberTile or a MineTile.
                tileRow[column].tiles.append(.CoverTile)             // Cover it with a CoverTile.
                numCovered += 1
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
        return (tiles)
    }
    
    func createTile(row: Int, column: Int) -> TileAttributes {
        let aMine = arc4random_uniform(99) + 1
        if aMine <= percentageOfMines { // how often do we create a mine?
            numMines += 1
            return TileAttributes(row: row, column: column, tiles: [.MineTile])
            
        } else {
            return TileAttributes(row: row, column: column, tiles: [.NumberTile])
        }

    }
    
    func actionTiles() -> [[TileAttributes]] {
        return tiles 
    }
    
    func prodForMines(row: Int, column: Int) -> Bool {
        //return true if mine explodes
        if tiles[row][column].tiles[1] == TileType.CoverTile {
            tiles[row][column].tiles[1] = TileType.NoTile
            numCovered -= 1
            if tiles[row][column].tiles[0] == TileType.MineTile{
                return true
            }else{
                clearSpace(row: row, column: column)
                return false
            }
        }else if tiles[row][column].tiles[1] == TileType.FlagTile {
            tiles[row][column].tiles[1] = TileType.CoverTile
        }
        return false
    }
    
    func didWin() -> Bool {
        if(numMines == numCovered){
            return true
        }
        return false
    }
    
    func numMinesUnflagged() -> Int{
        print("\(Double(numMines - numFlags))")
        return numMines - numFlags
    }
    
    func placeFlag(row: Int, column: Int) -> Bool{
        if tiles[row][column].tiles[1] == TileType.CoverTile {
            tiles[row][column].tiles[1] = TileType.FlagTile
            numFlags += 1
        }else if tiles[row][column].tiles[1] == TileType.FlagTile {
            tiles[row][column].tiles[1] = TileType.CoverTile
            numFlags -= 1
        }else if tiles[row][column].tiles[1] == TileType.NoTile {
            return clearVicinity(row: row, column: column)
        }
        return false
    }
    
    func revealMines(){
        for row in tiles{
            for cell in row{
                if cell.tiles[0] == TileType.MineTile{
                   // cell.tiles[1] = TileType.NoTile
                    }
                }
            }
        }

    func clearVicinity(row: Int, column: Int) -> Bool{
        var mines = 0
        var flags = 0
        for i in -1...1 {
            for j in -1...1 {
                if 0..<tiles.count ~= row+i,
                    0..<tiles[row].count ~= column+j{
                    if tiles[row+i][column+j].tiles[0] == TileType.MineTile{
                    mines += 1
                    }
                    if tiles[row+i][column+j].tiles[1] == TileType.FlagTile{
                        flags += 1
                    }
                }
            }
        }
        if mines == flags{
            for i in -1...1 {
                for j in -1...1 {
                    if 0..<tiles.count ~= row+i,
                        0..<tiles[row].count ~= column+j,
                        tiles[row+i][column+j].tiles[1] != TileType.FlagTile{
                        tiles[row+i][column+j].tiles[1] = TileType.NoTile
                        if tiles[row+i][column+j].tiles[0] == TileType.MineTile{
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func clearSpace(row: Int, column: Int) {
        tiles[row][column].tiles[1] = TileType.NoTile
        numCovered -= 1
        var isSafe = true
        for i in -1...1 {
            for j in -1...1 {
                if 0..<tiles.count ~= row+i,
                    0..<tiles[row].count ~= column+j,
                    tiles[row+i][column+j].tiles[0] == TileType.MineTile{
                    isSafe = false
                }
            }
        }
        if isSafe{
            for i in -1...1 {
                for j in -1...1 {
                    if 0..<tiles.count ~= row+i,
                        0..<tiles[row].count ~= column+j,
                        tiles[row+i][column+j].tiles[1] == TileType.CoverTile{
                        clearSpace(row: i+row, column: j+column)
                    }
                }
            }
        }
    }
}
