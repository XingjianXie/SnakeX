//
//  Game.swift
//  SnakeX
//
//  
//

import SwiftUI

extension Game {
    func update() {
        let result: GameResult = try! snake.moveToward(position: currentMovePosition, noPop: noPop)
        noPop = false
        _ = snake.contains { snakeBody in
            if snakeBody.at(gem) {
                noPop = true
                gem = Position(withRandomPosition: ())
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
}

extension Game {
    func reset(initialMovePosition: Position, initialGemPosition: Position, firstTime: Bool = false) {
        score = 0
        snake = [.Position(0, 0)]
        currentMovePosition = initialMovePosition
        gem = Position(withRandomPosition: ())
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
}

class Game: ObservableObject {
    var snake: Array<Position>!
    var currentMovePosition: Position!
    var noPop: Bool = false
    var gem: Position!
    var timer: Timer!
    @Published var started: Bool = true
    @Published var ended: Bool = false
    @Published var score: Int = 0
    @Published var field: Field!
    init(initialMovePosition: Position, initialGemPosition: Position) {
        reset(initialMovePosition: initialMovePosition, initialGemPosition: initialGemPosition, firstTime: true)
    }
}
