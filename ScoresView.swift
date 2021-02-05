

import SwiftUI

struct ScoresView: View {
    
    @EnvironmentObject var score: Score
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text("Partidas: \(score.games)")
                .font(.body)
            Spacer()
            Text("\(score.rows)")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Text("Record: \(score.maxRows)")
                .font(.body)
                .foregroundColor(.red)
        }
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        
        let score: Score = Score()
        score.newGame()
        score.rowCompleted()
        score.rowCompleted()
        score.rowCompleted()
        score.newGame()
        
        return ScoresView()
            .environmentObject(score)
    }
}

