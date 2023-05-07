//
//  BoardView.swift
//  Go
//
//  Created by home on 20/11/21.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var VM = BoardVM()
    
    var body: some View {
        VStack {
            Circle()
                .fill(VM.blackTurn ? Color.black : Color.white )
                .padding()
                .background(Color.gray)
                .frame(width: 100, height: 100)
            VStack {
                ForEach (0..<VM.board.count) { i in
                    HStack {
                        ForEach (0..<VM.board[0].count) { j in
                            Button(action: {
                                VM.makeTurn(i, j, doChange: true)
                            }, label: {
                                Color.green
                                    .overlay(Circle()
                                                .fill(VM.board [i][j] != 0 ? VM.board[i][j] == 1 ? Color.black : Color.white : Color.clear ))
                                
                            })
                            .disabled(VM.board[i][j] != 0)
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
            .background(Color.orange)
            HStack {
                Text("white:- \(VM.whiteScore)")
                Text("black:- \(VM.blackScore)")
            }
        }
        .alert(isPresented: $VM.win, content: {
            Alert(title: Text( VM.winner == 0 ? "draw" : (VM.winner == 1 ? "black" : "white") + " won with \(VM.points) points"), dismissButton: .default(Text("Play Again"),
                   action: {
                    VM.reset()
                   }))
        })
    }    
}



struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
