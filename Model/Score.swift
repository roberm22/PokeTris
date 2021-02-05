

import Foundation

class Score: ObservableObject {
    
    // Número de partidas jugadas
    @Published private(set) var games = 0
    
    // Nivel usado para seleccionar la velocidad
    @Published private(set) var level = 0
    
    // Máximo número de filas obtenido
    @Published private(set) var maxRows = 0
    
    // Número de filas completadas en la partida actual
    @Published private(set) var rows = 0
    
    // Número de fila a completar para aumentar level
    static let rowsToIncrementLevel = 5
    
    init() {
        load()
    }
    
    
    private func save() {
    
        let ud = UserDefaults.standard
        
        ud.set(games, forKey: "games")
        ud.set(maxRows, forKey: "maxScore")
        
        ud.synchronize()
    }
    
    private func load() {
        
        let ud = UserDefaults.standard
 
        games = ud.integer(forKey: "games")
        maxRows = ud.integer(forKey: "maxScore")
    }
    
    
    // Actualizar el estado para empezar una partida nueva
    func newGame() {
        games += 1
        level = 1
        rows = 0
                
        save()
    }
    
    // Actualizar la puntuacion al completarse/eliminarse una fila
    func rowCompleted() {
        rows += 1
        maxRows = max (rows,maxRows)
        if rows % Score.rowsToIncrementLevel == 0 {
            level += 1
        }
        
        save()
    }
}
