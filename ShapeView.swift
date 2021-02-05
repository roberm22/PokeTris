
import SwiftUI

// Pinta una shape
struct ShapeView: View {
    
    var shape: [[Texture?]]
    
    var borderColor = Color.red
    var bgColor = Color.white
    
    
    // Ancho de un bloque.
    var width: Int {
        height > 0 ? shape[0].count : 0
    }
    
    // Alto de un bloque.
    var height: Int {
        shape.count
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            let size = min(geometry.size.width / CGFloat(max(1,width)),
                           geometry.size.height / CGFloat(max(1,height)))

            LazyVGrid(columns: Array(repeating: GridItem(.fixed(size),
                                                         spacing: 0,
                                                         alignment: .center),
                                     count: width),
                      alignment: .center,
                      spacing: 0,
                      pinnedViews: []) {
                ForEach(0..<height, id: \.self) { r in
                    ForEach(0..<width, id: \.self) { c in
                        if let texture = shape[r][c] {
                            ZStack {
                                Image(texture.backgroundImageName)
                                    .resizable()
                                    .scaledToFill()
                                Image(texture.pokemonImageName)
                                    .resizable()
                                    .scaledToFill()
                            }
                            
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
        }
        .aspectRatio(CGSize(width: max(1,width), height: max(1,height)), contentMode: .fit)
        .background(bgColor)
        .overlay(Rectangle()
                    .stroke(borderColor))
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShapeView(shape: Block.random().shape)
            ShapeView(shape: [[Texture?]]())
        }
    }
}
