

import SwiftUI

@main
struct PokeTrisApp: App {
   
    var body: some Scene {
        
        let score = Score()

        let board = Board(score: score)
        
        board.newGame()

        return WindowGroup {
            ContentView()
                .environmentObject(board)
                .environmentObject(score)
        }
    }
}
 
