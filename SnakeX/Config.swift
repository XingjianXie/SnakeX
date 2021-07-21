//
//  Config.swift
//  SnakeX
//
//  
//

import SwiftUI

var timeInterval = 0.15
var size = 20
var auto = false
var enduring = false
var loop = true
var obliqe = false

extension Game {
    func moveTowardGem() {
        let xMove = (self.gem[0] - self.snake[0][0]).signum()
        var yMove = (self.gem[1] - self.snake[0][1]).signum()
        if xMove != 0 && yMove != 0 && !obliqe {
            yMove = 0
        }
        currentMovePosition = .Position(xMove, yMove)
    }
}
