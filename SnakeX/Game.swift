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
    var snake: Array<FieldType>!
    var currentMovePosition: Position!
    var noPop: Bool = false
    var gem: FieldType!
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
                gem = FieldType.Gem(position: Position(withRandomPosition: ()))
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
    func reset(initialMovePosition: Position, initialGemPosition: Position, firstTime: Bool = false) {
        score = 0
        snake = [FieldType.SnakeBody(position: .Position(0, 0))]
        currentMovePosition = initialMovePosition
        gem = FieldType.Gem(position: Position(withRandomPosition: ()))
        field = Field(game: self)
        field.update()
        if !firstTime {
            self.timer.invalidate()
        }
        
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
        reset(initialMovePosition: initialMovePosition, initialGemPosition: initialGemPosition, firstTime: true)
    }
}
