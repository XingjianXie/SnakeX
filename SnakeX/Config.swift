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
        let xMove = (self.gem.position[0] - self.snake[0].position[0]).signum()
        var yMove = (self.gem.position[1] - self.snake[0].position[1]).signum()
        if xMove != 0 && yMove != 0 && !obliqe {
            yMove = 0
        }
        currentMovePosition = Position(x: xMove, y: yMove)
    }
}
