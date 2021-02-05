

import Foundation
import Combine

class Board: ObservableObject {
        
    var score: Score

    // Tamaño del tablero
    let columnsCount = 8
    let rowsCount = 13
    
    // Para guardar las subscripciones a los publishers auxiliares
    private var shapeSubscription: AnyCancellable?
    private var timerSubscription: AnyCancellable?

    // Contenido del tablero. Solo las piezas congeladas.
    @Published private(set) var shape = [[Texture?]]()

    // El siguiente bloque que aparecera.
    @Published private(set) var nextBlock: Block?
    
    // El bloque que esta cayendo ahora
    @Published private(set) var currentBlock: Block?
    @Published private(set) var currentBlockColumn: Int = 0
    @Published private(set) var currentBlockRow: Int = 0
    
    @Published private(set) var gameInProgress = false
   
    // Contenido del tablero y del bloque que esta cayendo.
    @Published private(set) var boardAndCurrentBlockShape = [[Texture?]]()

    // Creamos un Publisher que publica un array uniendo las texturas del tablero (shape) y las
    // texturas del bloque actual (currentBlock).
    private var boardAndCurrentBlockShapePublisher: AnyPublisher<[[Texture?]], Never> {
        Publishers.CombineLatest4($shape, $currentBlock, $currentBlockColumn, $currentBlockRow)
            .map { shape, currentBlock, currentBlockColumn, currentBlockRow in
                var joinShape = shape
                
               if let currentBlock = currentBlock {
                    let width  = currentBlock.width
                    let height = currentBlock.height
                    
                    for r in 0..<height {
                        for c in 0..<width {
                            let boardColumn = c + currentBlockColumn
                            let boardRow = r + currentBlockRow
                            if boardColumn < 0 || boardColumn >= self.columnsCount ||
                                boardRow < 0 || boardRow >= self.rowsCount {
                                continue
                            }
                            if currentBlock[r, c] != nil {
                                joinShape[boardRow][boardColumn] = currentBlock[r, c]
                            }
                        }
                    }
                }
            
                return joinShape
            }
            .eraseToAnyPublisher()
    }
       
   
    init(score: Score) {
        self.score = score
        
        // Guardamos lo que publica este Publisher en la propiedad boardAndCurrentBlockShape,
        // para que lo pinten las view.
        shapeSubscription = boardAndCurrentBlockShapePublisher
            //.receive(on: RunLoop.main)
            .assign(to: \.boardAndCurrentBlockShape, on: self)
    }
    
    func newGame() {
        
        score.newGame()

        let row = [Texture?](repeating: nil, count: columnsCount)
        shape = [[Texture?]](repeating: row, count: rowsCount)
        
        insertNewBlock()
        
        gameInProgress = true
        
        let interval: TimeInterval = 0.800 - (0.050 * TimeInterval(score.level))   
        timerSubscription = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in self.autoMoveDown()})
    }
    
    
    private func insertNewBlock() {
        
        currentBlock = nextBlock ?? Block.random()
        
        currentBlockColumn = columnsCount/2 - currentBlock!.width/2
        currentBlockRow = 1 - currentBlock!.height
        
        if onCollision() {
            
            currentBlock = nil
            nextBlock = nil
            
            // Game Over:
            timerSubscription?.cancel()
            gameInProgress = false
            
        } else {
            nextBlock = Block.random()
        }
    }
    
    
   private func autoMoveDown() {

       guard gameInProgress else { return }

       moveDown(insertNewBlockIfNeeded: true)
   }

    
    func rotate(toRight: Bool) {
        
        if currentBlock == nil { return }
            
        let oldBlock = currentBlock
        let oldColumn  = currentBlockColumn
                
        currentBlock!.rotate(toRight: toRight)
        
        while isOutAtLeft() {
            currentBlockColumn += 1
        }
        while isOutAtRight() {
            currentBlockColumn -= 1
        }
        
        if isOutAtBottom() || onCollision() {
            currentBlock = oldBlock
            currentBlockColumn = oldColumn
        }
    }
    
    
    func moveLeft() {

        if currentBlock == nil { return }
        
        currentBlockColumn -= 1
        if isOutAtLeft() || onCollision() {
            currentBlockColumn += 1
        }
    }
    
    func moveRight() {
        
        if currentBlock == nil { return }

        currentBlockColumn += 1
        if isOutAtRight() || onCollision() {
            currentBlockColumn -= 1
        }
    }
    
    func moveDown(insertNewBlockIfNeeded inbin: Bool = false) {
        
        if currentBlock == nil { return }

        currentBlockRow += 1
        if isOutAtBottom() || onCollision() {
            currentBlockRow -= 1
            if inbin {
                addToBoard()
                insertNewBlock()
            }
        }
    }
    
    func dropDown() {
        
        if currentBlock == nil { return }
        
        repeat {
            currentBlockRow += 1
        } while !isOutAtBottom() && !onCollision()
        currentBlockRow -= 1
    }
    
    private func isOutAtLeft() -> Bool {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for c in 0..<width where c + currentBlockColumn < 0 {
            for r in 0..<height {
                if currentBlock![r, c] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    
    private func isOutAtRight() -> Bool {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for c in (0..<width).reversed() where c + currentBlockColumn >= columnsCount {
            for r in 0..<height {
                if currentBlock![r, c] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    
    private func isOutAtBottom() -> Bool {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for r in (0..<height).reversed() where r + currentBlockRow >= rowsCount {
            for c in 0..<width {
                if currentBlock![r, c] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    // Devuelve true si el block actual colisiona con el contenido del Tablero.
    private func onCollision() -> Bool {
                
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for r in 0..<height {
            // Ignorar las filas que no han entrado en el tablero
            if r + currentBlockRow < 0 {
                continue
            }
            
            for c in 0..<width {
                if currentBlock![r, c] != nil {
                    if shape[r + currentBlockRow][c + currentBlockColumn] != nil {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    private func isRowCompleted(rowIndex: Int) -> Bool {
        for c in 0..<columnsCount {
            if shape[rowIndex][c] == nil {
                return false
            }
        }
        return true
    }
    
    
    private func removeCompletedRows() {
        for r in (0..<rowsCount).reversed() {
            while isRowCompleted(rowIndex: r) {
                score.rowCompleted()
                compactEmptyRow(rowIndex: r)
            }
        }
    }
    
    private func compactEmptyRow(rowIndex: Int) {
        
        for r in (0..<rowIndex).reversed() {
            shape[r + 1] = shape[r];
        }
        shape[0] =  [Texture?](repeating: nil, count: columnsCount)
    }
    
    
    // Congela/rellena el bloque actual en el tablero
    private func addToBoard() {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height

        for r in 0..<height {
            for c in 0..<width {
                let boardColumn = c + currentBlockColumn
                let boardRow = r + currentBlockRow
                if boardColumn < 0 || boardColumn >= columnsCount ||
                    boardRow < 0 || boardRow >= rowsCount {
                    continue
                }
                if currentBlock![r, c] != nil {
                    shape[boardRow][boardColumn] = currentBlock![r, c]
                }
            }
        }
        
        removeCompletedRows()
    }
}



extension Board : CustomStringConvertible {
    public var description: String {
        
        let s = shape.map {row in
            row.map {texture in String(format: "%3d", texture ?? -1)}.joined(separator: " ")
            }.joined(separator: "\n")
        
        return "Board:\n\(s)\n\nCurrent: \(currentBlockRow) - \(currentBlockColumn)\n\(currentBlock!)\n\nNext:\n\(nextBlock!)"
        
    }
}

