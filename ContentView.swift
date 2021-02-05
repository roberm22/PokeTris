

import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject var board: Board
	@Environment(\.verticalSizeClass) var verticalSizeClass
	@GestureState var swipeLastPos: CGFloat = 0
	
	private var headerView: some View {
		HStack {
			Spacer()
			Image("poketris")
				.resizable()
				.scaledToFit()
			Spacer()
			if board.nextBlock != nil {
				ShapeView(shape: board.nextBlock!.shape,
						  borderColor: .clear,
						  bgColor: .clear)
					.padding(5)
			}
		}
		.frame(height: 60)
		.padding(.top)
	}
	
	var body: some View {
		ZStack {
			Rectangle()
				.fill(Color("fondoApp"))
				.ignoresSafeArea()
			
			if verticalSizeClass != .compact{
				VStack(alignment: .center, spacing: 0) {
					headerView
					ScoresView()
					Spacer()
					ShapeView(shape: board.boardAndCurrentBlockShape)
					Spacer()
					ControlPanel()
						.frame(maxHeight: 60)
				}
				.padding(.horizontal)
				
			}else{
				HStack{
					VStack(alignment: .center, spacing: 0) {
						ScoresView()
						Spacer()
						ControlPanelHorizontalizquierda()
							.frame(maxHeight: 180)
						
					}
					.padding(.horizontal)
					ShapeView(shape: board.boardAndCurrentBlockShape)
					VStack{
						Spacer()
						ControlPanerlHorizontalderecha()
							.frame(maxHeight: 180)
					}
				}
			}
		}
		.onTapGesture(count: 1) {
			board.rotate(toRight: true)
		}
		.gesture(
			DragGesture(minimumDistance: 0, coordinateSpace: .local)
				.updating($swipeLastPos) { value, state, transaction in
					if value.translation.width - swipeLastPos > 25 {
						board.moveRight()
						state = value.translation.width
					} else if value.translation.width - swipeLastPos < -25 {
						board.moveLeft()
						state = value.translation.width
					} else if value.translation.height > 25 {
						board.dropDown()
					}
				})
		.alert(isPresented: .constant(!board.gameInProgress)) {
			Alert(title: Text("Game Over"),
				  message: Text("¿Quieres jugar otra partida?"),
				  dismissButton: .default(Text("Si")) {
					board.newGame()
				  })
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		
		let score: Score = Score()
		
		let board = Board(score: score)
		board.newGame()
		board.dropDown()
		board.moveDown(insertNewBlockIfNeeded: true)
		board.dropDown()
		board.moveDown(insertNewBlockIfNeeded: true)
		
		return Group {
			ContentView()
				.previewLayout(.fixed(width: 568, height: 320))
				.environmentObject(board)
				.environmentObject(score)
			
		}
	}
}
