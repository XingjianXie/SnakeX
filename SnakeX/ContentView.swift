//
//  ContentView.swift
//  Shared
//
//  Created by 谢行健 on 2021/3/9.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: Game = Game(initialMovePosition: Position.moveRight, initialGemPosition: Position())
    @State var snakeBodyColor: Color = Color.pink
    @State var snakeHeadColor: Color = Color.yellow
    @State var gemColor: Color = Color.blue
    var body: some View {
        GeometryReader { proxy in
            if game.ended || !game.started {
                MenuView(game: game, proxy: proxy)
            } else {
                VStack {
                    GameField(contentView: self)
                    Divider()
                    ColorPickerView(contentView: self)
                    Divider()
                    OperationButtonView(contentView: self)
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MenuView: View {
    let game: Game
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
                    game.reset(initialMovePosition: Position.moveRight, initialGemPosition: Position())
                    game.ended = false
                }.font(.title).buttonStyle(BorderlessButtonStyle())
                if !game.ended && !game.started {
                    Button("Continue") {
                        game.started = true
                    }.font(.title).buttonStyle(BorderlessButtonStyle())
                }
                
                Group {
                    TextField("Time Interval", text: .init(get: { return String(timeInterval) }, set: { game.ended  = true; timeInterval = Double($0) ?? 0 })).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Size", text: .init(get: { return String(size) }, set: { game.ended  = true; size = Int($0) ?? 0 })).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Toggle("Auto", isOn: .init(get: { return auto }, set: { game.ended  = true; auto = $0; if $0 { enduring = true } }))
                    Toggle("Enduring", isOn: .init(get: { return enduring }, set: { game.ended  = true; enduring = $0; if !$0 { auto = false } }))
                    Toggle("Cycle", isOn: .init(get: { return cycle }, set: { game.ended  = true; cycle = $0 }))
                    Toggle("Obliqe", isOn: .init(get: { return obliqe }, set: { game.ended  = true; obliqe = $0 }))
                    
                }.frame(
                    width: proxy.size.width * 0.35
                )
            }
        }.padding()
    }
}

struct GameField: View {
    let contentView: ContentView
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<size, id: \.self) {i in
                    HStack(spacing: 0) {
                        ForEach(0..<size, id: \.self) {j in
                            let fieldObject: FieldObject? = contentView.game.field[Position(x: i, y: j)]
                            if fieldObject is SnakeHead {
                                Rectangle().fill(contentView.snakeHeadColor)
                            } else if fieldObject is SnakeBody {
                                Rectangle().fill(contentView.snakeBodyColor)
                            } else if fieldObject is Gem {
                                Rectangle().fill(contentView.gemColor)
                            } else {
                                Rectangle().fill(Color.white)
                            }
                        }
                    }
                }
            }.aspectRatio(1, contentMode: .fit).border(Color.secondary).padding()
            Text("Score: \(contentView.game.score)").font(.largeTitle).bold()
        }
    }
}

struct ColorPickerView: View {
    let contentView: ContentView
    let colors: [Color] = [.gray, .red, .green, .blue, .orange, .yellow, .pink, .purple]
    var body: some View {
        VStack {
            HStack {
                Text("Snake Head")
                Spacer()
                ForEach(colors.indices, id: \.self) { i in
                    Button(action: { contentView.snakeHeadColor = colors[i] }) {
                        Text(Image(systemName: "square.fill")).foregroundColor(colors[i])
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            HStack {
                Text("Snake Body")
                Spacer()
                ForEach(colors.indices, id: \.self) { i in
                    Button(action: { contentView.snakeBodyColor = colors[i] }) {
                        Text(Image(systemName: "square.fill")).foregroundColor(colors[i])
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            HStack {
                Text("Gem")
                Spacer()
                ForEach(colors.indices, id: \.self) { i in
                    Button(action: { contentView.gemColor = colors[i] }) {
                        Text(Image(systemName: "square.fill")).foregroundColor(colors[i])
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
        }.padding(.horizontal)
    }
}

struct OperationButtonView: View {
    let contentView: ContentView
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if obliqe {
                    Button(action: { contentView.game.currentMovePosition = Position.moveUpLeft }) {
                        Image(systemName: "arrow.up.left.circle").font(.largeTitle)
                    }.keyboardShortcut("q", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                }
                Button(action: { contentView.game.currentMovePosition = Position.moveUp }) {
                    Image(systemName: "arrow.up.circle").font(.largeTitle)
                }.keyboardShortcut("w", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                if obliqe {
                    Button(action: { contentView.game.currentMovePosition = Position.moveUpRight }) {
                        Image(systemName: "arrow.up.right.circle").font(.largeTitle)
                    }.keyboardShortcut("e", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                }
            }
            
            HStack(spacing: 0) {
                Button(action: { contentView.game.currentMovePosition = Position.moveLeft }) {
                    Image(systemName: "arrow.left.circle").font(.largeTitle)
                }.keyboardShortcut("a", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                
                Button(action: { contentView.game.started.toggle() }) {
                    Image(systemName: "square.fill").font(.largeTitle)
                }.keyboardShortcut(" ", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                
                Button(action: { contentView.game.currentMovePosition = Position.moveRight }) {
                    Image(systemName: "arrow.right.circle").font(.largeTitle)
                }.keyboardShortcut("d", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
            }
            HStack(spacing: 0) {
                if obliqe {
                    Button(action: { contentView.game.currentMovePosition = Position.moveDownLeft }) {
                        Image(systemName: "arrow.down.left.circle").font(.largeTitle)
                    }.keyboardShortcut("z", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                }
                Button(action: { contentView.game.currentMovePosition = Position.moveDown }) {
                    Image(systemName: "arrow.down.circle").font(.largeTitle)
                }.keyboardShortcut("s", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                if obliqe {
                    Button(action: { contentView.game.currentMovePosition = Position.moveDownRight }) {
                        Image(systemName: "arrow.down.right.circle").font(.largeTitle)
                    }.keyboardShortcut("c", modifiers: []).buttonStyle(BorderlessButtonStyle()).padding()
                }
            }
        }.aspectRatio(1, contentMode: .fill)
    }
}
