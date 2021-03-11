//
//  Game.swift
//  SnakeX
//
//  Created by 谢行健 on 2021/3/9.
//

import SwiftUI

enum GameResult {
    case crashWall
    case crashBody
    case continueGame
}

class Game: ObservableObject {
    var snake: Snake
    var currentMovePosition: Position
    var noPop: Bool = false
    var gem: Gem
    var timer: Timer!
    @Published var started: Bool = true
    @Published var ended: Bool = false
    @Published var score: Int = 0
    @Published var field: Field!
    func update() {
        let result: GameResult = try! snake.moveToward(position: currentMovePosition, noPop: noPop)
        noPop = false
        _ = snake.contains { snakeBody in
            if snakeBody.position.at(gem.position) {
                noPop = true
                gem = Gem(position: Position())
                score += 1
                return true
            }
            return false
        }
        
        field.update()
        switch result {
        case .crashBody, .crashWall:
            started = false
            ended = true
        default:
            break
        }
    }
    func reset(initialMovePosition: Position, initialGemPosition: Position) {
        score = 0
        snake = [SnakeBody(position: [0, 0])]
        currentMovePosition = initialMovePosition
        gem = Gem(position: Position())
        field = Field(game: self)
        field.update()
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            if self.started {
                if auto {
                    self.moveTowardGem()
                }
                self.update()
            }
        }
        self.started = true
    }
    init(initialMovePosition: Position, initialGemPosition: Position) {
        snake = [SnakeBody(position: [0, 0])]
        currentMovePosition = initialMovePosition
        gem = Gem(position: Position())
        field = Field(game: self)
        field.update()
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            if self.started {
                if auto {
                    self.moveTowardGem()
                }
                self.update()
            }
        }
    }
}
