

import SwiftUI

typealias Texture = Int

extension Texture {
    
    static let backgroundCount = 7
    static let pokemonsCount = 151
    
    var backgroundImageName: String {
        String(format: "bg%d", self % Texture.backgroundCount)
    }
    
    var pokemonImageName: String {
        String(format: "%03d", self % Texture.pokemonsCount + 1)
    }
}
