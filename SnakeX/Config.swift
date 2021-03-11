//
//  Config.swift
//  SnakeX
//
//  Created by 谢行健 on 2021/3/10.
//

import SwiftUI

var timeInterval = 0.15
var size = 20
var auto = false
var enduring = false
var cycle = true
var obliqe = false

extension Game {
    func moveTowardGem() {
        switch true {
        case self.snake[0].position[0] < self.gem.position[0] && self.snake[0].position[1] < self.gem.position[1] && obliqe:
            currentMovePosition = Position.moveDownRight
        case self.snake[0].position[0] < self.gem.position[0] && self.snake[0].position[1] > self.gem.position[1] && obliqe:
            currentMovePosition = Position.moveDownLeft
        case self.snake[0].position[0] > self.gem.position[0] && self.snake[0].position[1] < self.gem.position[1] && obliqe:
            currentMovePosition = Position.moveUpRight
        case self.snake[0].position[0] > self.gem.position[0] && self.snake[0].position[1] > self.gem.position[1] && obliqe:
            currentMovePosition = Position.moveUpLeft
        case self.snake[0].position[0] < self.gem.position[0]:
            currentMovePosition = Position.moveDown
        case self.snake[0].position[0] > self.gem.position[0]:
            currentMovePosition = Position.moveUp
        case self.snake[0].position[1] < self.gem.position[1]:
            currentMovePosition = Position.moveRight
        case self.snake[0].position[1] > self.gem.position[1]:
            currentMovePosition = Position.moveLeft
        default:
            break
        }
    }
}
