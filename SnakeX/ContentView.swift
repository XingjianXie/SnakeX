//
//  ContentView.swift
//  SnakeX
//
//  
//

import SwiftUI

typealias ColorConfig = (snakeHeadColor: Color, snakeBodyColor: Color, gemColor: Color)

struct ContentView: View {
    @ObservedObject var game: Game = Game(initialMovePosition: Position.moveRight, initialGemPosition: Position(withRandomPosition: ()))
    @State var colorConfig: ColorConfig = (Color.yellow, Color.pink, Color.blue)
    var body: some View {
        GeometryReader { proxy in
            if game.ended || !game.started {
                MenuView(proxy: proxy)
            } else {
                VStack {
                    GameField(colorConfig: $colorConfig)
                    Divider()
                    ColorPickerView(colorConfig: $colorConfig)
                    Divider()
                    OperationButtonsView()
                    Spacer()
                }
            }
        }.environmentObject(game)
    }
}

struct MenuView: View {
    @EnvironmentObject var game: Game
    let proxy: GeometryProxy
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondary, lineWidth: 1).background(Color.white)
            VStack {
                if game.ended {
                    Text("Game Ended").font(.title).bold()
                } else if !game.started {
                    Text("Pause").font(.title).bold()
                }
                Text("Score: \(game.score)").font(.title)
                Button("New Game") {
                    game.reset(initialMovePosition: Position.moveRight, initialGemPosition: Position(withRandomPosition: ()))
                    game.ended = false
                }.font(.title).buttonStyle(BorderlessButtonStyle())
                Button("Continue") {
                    game.started = true
                }.font(.title).buttonStyle(BorderlessButtonStyle()).keyboardShortcut(" ", modifiers: []).buttonStyle(BorderlessButtonStyle()).disabled(game.ended || game.started)
                
                Group {
                    TextField("Time Interval", text: .init(get: { return String(timeInterval) }, set: { game.ended  = true; timeInterval = Double($0) ?? 0 })).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Size", text: .init(get: { return String(size) }, set: { game.ended  = true; size = Int($0) ?? 0 })).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Toggle("Auto", isOn: .init(get: { return auto }, set: { auto = $0; if $0 { enduring = true }; game.objectWillChange.send() }))
                    Toggle("Enduring", isOn: .init(get: { return enduring }, set: { enduring = $0; if !$0 { auto = false }; game.objectWillChange.send() }))
                    Toggle("Loop", isOn: .init(get: { return loop }, set: { loop = $0; game.objectWillChange.send() }))
                    Toggle("Obliqe", isOn: .init(get: { return obliqe }, set: { obliqe = $0; game.objectWillChange.send() }))
                    
                }.frame(
                    width: proxy.size.width * 0.35
                )
            }
        }.padding()
    }
}

struct GameField: View {
    @EnvironmentObject var game: Game
    @Binding var colorConfig: ColorConfig
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<size, id: \.self) {i in
                    HStack(spacing: 0) {
                        ForEach(0..<size, id: \.self) {j in
                            let type = game.field[.Position(i, j)]
                            switch type {
                            case .SnakeHead:
                                Rectangle().fill(colorConfig.snakeHeadColor)
                            case .SnakeBody:
                                Rectangle().fill(colorConfig.snakeBodyColor)
                            case .Gem:
                                Rectangle().fill(colorConfig.gemColor)
                            case .none:
                                Rectangle().fill(Color.white)
                            }
                        }
                    }
                }
            }.aspectRatio(1, contentMode: .fit).border(Color.secondary).padding()
            Text("Score: \(game.score)").font(.largeTitle).bold()
        }
    }
}

struct ColorPickerView: View {
    @EnvironmentObject var game: Game
    @Binding var colorConfig: (snakeHeadColor: Color, snakeBodyColor: Color, gemColor: Color)
    let colors: [Color] = [.gray, .red, .green, .blue, .orange, .yellow, .pink, .purple]
    var body: some View {
        VStack {
            HStack {
                Text("Snake Head")
                Spacer()
                ForEach(colors.indices, id: \.self) { i in
                    Button(action: { colorConfig.snakeHeadColor = colors[i] }) {
                        Text(Image(systemName: "square.fill")).foregroundColor(colors[i])
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            HStack {
                Text("Snake Body")
                Spacer()
                ForEach(colors.indices, id: \.self) { i in
                    Button(action: { colorConfig.snakeBodyColor = colors[i] }) {
                        Text(Image(systemName: "square.fill")).foregroundColor(colors[i])
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            HStack {
                Text("Gem")
                Spacer()
                ForEach(colors.indices, id: \.self) { i in
                    Button(action: { colorConfig.gemColor = colors[i] }) {
                        Text(Image(systemName: "square.fill")).foregroundColor(colors[i])
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
        }.padding(.horizontal)
    }
}

struct OperationButtonsView: View {
    @EnvironmentObject var game: Game
    fileprivate func OperationButton(_ action: @escaping () -> (), _ image: String, _ key: KeyEquivalent) -> some View {
        return Button(action: action) {
            Image(systemName: image).font(.largeTitle)
        }.keyboardShortcut(key, modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if obliqe {
                    OperationButton({ game.currentMovePosition = Position.moveUpLeft }, "arrow.up.left.circle", "q")
                }
                OperationButton({ game.currentMovePosition = Position.moveUp }, "arrow.up.circle", "w")
                if obliqe {
                    OperationButton({ game.currentMovePosition = Position.moveUpRight }, "arrow.up.right.circle", "e")
                }
            }
            HStack(spacing: 0) {
                OperationButton({ game.currentMovePosition = Position.moveLeft }, "arrow.left.circle", "a")
                OperationButton({ game.started.toggle() }, "square.fill", " ")
                OperationButton({ game.currentMovePosition = Position.moveRight }, "arrow.right.circle", "d")
            }
            HStack(spacing: 0) {
                if obliqe {
                    OperationButton({ game.currentMovePosition = Position.moveDownLeft }, "arrow.down.left.circle", "z")
                }
                OperationButton({ game.currentMovePosition = Position.moveDown }, "arrow.down.circle", "s")
                if obliqe {
                    OperationButton({ game.currentMovePosition = Position.moveDownRight }, "arrow.down.right.circle", "c")
                }
            }
        }.aspectRatio(1, contentMode: .fill)
    }
}
