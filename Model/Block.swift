

import Foundation


struct Block {
    
    // Forma y textura de las casillas del Bloque
    fileprivate(set) var shape: [[Texture?]]

    init(mask: [[Bool]], texture: Texture) {
        self.shape = mask.map {
            $0.map { $0 ? texture : nil }
        }
    }
    
    subscript(row: Int, column: Int) -> Texture? {
        shape[row][column]
    }
}


// Medidas
extension Block {
    
    // Ancho de un bloque.
    var width: Int {
        shape[0].count
    }
    
    // Alto de un bloque.
    var height: Int {
        shape.count
    }
}


// Rotaciones
extension Block {
    
    mutating func rotate(toRight: Bool) {
        if toRight {
            rotateRight()
        } else {
            rotateLeft()
        }
    }

    mutating func rotateRight() {
        var newShape = [[Texture?]]()
        for c in 0..<width {
            var newRow = [Texture?]()
            for r in 0..<height {
                newRow.insert(shape[r][c], at: 0)
            }
            newShape.append(newRow)
        }
        shape = newShape
    }
    
    mutating func rotateLeft() {
        var newShape = Array(repeating: [Texture?](repeating: nil,
                                                   count: height),
                             count: width)
        for c in 0..<width {
            for r in 0..<height {
                newShape[width-c-1][r] = shape[r][c]
            }
        }
        shape = newShape
    }
}


// Crear block aleatorio
extension Block {
    
    static func random() -> Block {
        
        var mask: [[Bool]]
        
        let texture = Int(arc4random_uniform(UInt32(Texture.pokemonsCount)))
        
        switch texture % Texture.backgroundCount {
        case 0:
            mask = [[false, true, false],
                    [false, true, false],
                    [false, true, false],
                    [false, true, false]]
        case 1:
            mask = [[true, true],
                    [true, true]]
        case 2:
            mask = [[false, true,   false],
                    [true,  true,   true],
                    [false, false,  false]]
        case 3:
            mask = [[false, true, false],
                    [false, true, false],
                    [true,  true, false]]
        case 4:
            mask = [[false, true],
                    [true,  true],
                    [true,  false]]
        default:
            mask = [[true,  false],
                    [true,  true],
                    [false, true]]
        }
        
        var block = Block(mask: mask, texture: texture)
        
        // La rotacion
        switch Int(arc4random_uniform(4)) {
        case 0:
            block.rotateRight()
        case 1:
            block.rotateRight()
            block.rotateRight()
        case 2:
            block.rotateLeft()
        default:
            break
        }
        
        return block
    }
}


extension Block : CustomStringConvertible {
    public var description: String {
        
        shape.map {
            $0.map {$0 != nil ? "\($0!)" : "_"}.joined(separator: "")
        }.joined(separator: "\n")
    }
}

