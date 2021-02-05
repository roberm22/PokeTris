
import SwiftUI

struct ControlPanelHorizontalizquierda: View {
	
	@EnvironmentObject var board: Board
	
	var body: some View {
		VStack {
			HStack{
				Image("move_left")
					.resizable()
					.scaledToFit()
					.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
						board.moveLeft()
					}
				Image("move_right")
					.resizable()
					.scaledToFit()
					.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
						board.moveRight()
					}
				
			}

			Image("move_down")
				.resizable()
				.scaledToFit()
				.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
					board.moveDown()
				}
			
			
			
		}
	}
}
struct ControlPanelHorizontalizquierda_Preview: PreviewProvider {
	static var previews: some View {
		ControlPanelHorizontalizquierda()
	}
}

