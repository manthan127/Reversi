//
//  VM.swift
//  Go
//
//  Created by home on 29/11/21.
//

import SwiftUI

extension Array{
    subscript(safe index: Index) -> Element? {
        (0..<count) ~= index ? self[index] : nil
    }
}


class BoardVM: ObservableObject {
    @Published var board = Array(repeating: Array(repeating: 0, count: 8), count: 3) + [[0,0,0,2,1,0,0,0],[0,0,0,1,2,0,0,0]] + Array(repeating: Array(repeating: 0, count: 8), count: 3)
    
    var blackTurn = true
    var points = 0
    @Published var win = false
    var winner = 0
    var whiteScore = 0
    var blackScore = 0
    
    func reset(){
        board = Array(repeating: Array(repeating: 0, count: 8), count: 3) + [[0,0,0,2,1,0,0,0],[0,0,0,1,2,0,0,0]] + Array(repeating: Array(repeating: 0, count: 8), count: 3)
        blackTurn = true
        win = false
        winner = 0
    }
    
    @discardableResult
    func makeTurn(_ row: Int, _ colum: Int, doChange: Bool) -> Bool {
        let opponet = blackTurn ? 2 : 1
        let player = blackTurn ? 1 : 2
        var placeOfOpponets = [(Int,Int)]()
        
        for dy in -1...1{
            for dx in -1...1 where dy != 0 || dx != 0 {
                var tempPlaceHolder = [(Int, Int)]()
                var curRow = row + dy
                var curColum = colum + dx
                
                while board[safe: curRow]?[safe: curColum] ?? opponet != player {
                    if board[safe: curRow]? [safe :curColum] ?? 0 == 0{
                        tempPlaceHolder = []
                        break
                    }
                    
                    tempPlaceHolder.append((curRow, curColum))
                    curRow += dy
                    curColum += dx
                }
                if !doChange && tempPlaceHolder.count > 0 {
                    return true
                }
                placeOfOpponets.append(contentsOf: tempPlaceHolder)
            }
        }
        
        if placeOfOpponets.count != 0 {
            whiteScore = 0
            blackScore = 0
            for i in board {
                blackScore += i.filter{$0 == 1}.count
                whiteScore += i.filter{$0 == 2}.count
            }
            
            board[row][colum] = blackTurn ? 1 : 2
            for i in placeOfOpponets {
                board[i.0][i.1] = blackTurn ? 1 : 2
            }
            blackTurn.toggle()
            if cheakAllPos() {
                blackTurn.toggle()
                if cheakAllPos() {
                    winnerD()
                }
            }
        }
        return false
    }
    
    func cheakAllPos() -> Bool {
        for i in board.indices {
            for j in board[0].indices
            where board[i][j] == 0 && makeTurn(i, j, doChange: false) {
                return false
            }
        }
        
        return true
    }
    
    func winnerD() {
        if blackScore != whiteScore {
            winner = blackScore > whiteScore ? 1 : 2
            points = max(blackScore,whiteScore)
        }
        win = true
    }
}
