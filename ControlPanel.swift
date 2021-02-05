

import SwiftUI

struct ControlPanel: View {
    
    @EnvironmentObject var board: Board
    
    var body: some View {
        HStack {
            Image("move_left")
                .resizable()
                .scaledToFit()
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
                    board.moveLeft()
                }
            Spacer()
            Image("rotate_right")
                .resizable()
                .scaledToFit()
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
                    board.rotate(toRight: true)
                }
            Spacer()
            Image("move_right")
                .resizable()
                .scaledToFit()
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
                    board.moveRight()
                }
            Spacer()
            Image("move_down")
                .resizable()
                .scaledToFit()
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
                    board.moveDown()
                }
            Spacer()
            Image("rotate_left")
                .resizable()
                .scaledToFit()
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
                    board.rotate(toRight: false)
                }
        }
    }
}

struct ControlPanel_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanel()
    }
}
