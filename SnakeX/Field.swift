//
//  Field.swift
//  SnakeX
//
//  Created by 谢行健 on 2021/3/9.
//

import SwiftUI

enum FieldObject {
    case SnakeHead(position: Position)
    case SnakeBody(position: Position)
    case Gem(position: Position)
    var position: Position {
        switch self {
        case .SnakeHead(let p):
            return p
        case .SnakeBody(let p):
            return p
        case .Gem(let p):
            return p
        }
    }
}

typealias Snake = [FieldObject]

enum GameError: Error {
    case emptySnake
}

extension Snake {
    mutating func moveToward(position: Position, noPop: Bool) throws -> GameResult {
        if self.count == 0 {
            throw GameError.emptySnake
        }
        let newHeadPosition: Position = self[0].position.with(offset: position)
        if !newHeadPosition.withinBorder {
            return .crashWall
        }
        if self.contains(where: { $0.position.at(newHeadPosition) }) && !enduring {
            return .crashBody
        }
        let newHead: FieldObject = FieldObject.SnakeBody(position: newHeadPosition)
        self.insert(newHead, at: 0)
        if !noPop {
            _ = self.popLast()
        }
        return .continueGame
    }
}

typealias Position = [Int]

extension Position {
    static var moveUp: Position { [-1, 0] }
    static var moveUpLeft: Position { [-1, -1] }
    static var moveUpRight: Position { [-1, 1] }
    static var moveDown: Position { [1, 0] }
    static var moveDownLeft: Position { [1, -1] }
    static var moveDownRight: Position { [1, 1] }
    static var moveLeft: Position { [0, -1] }
    static var moveRight: Position { [0, 1] }
    
    var withinBorder: Bool { 0..<size ~= self[0] && 0..<size ~= self[1] }
    func with(offset: Position) -> Position {
        if cycle {
            return [(self[0] + offset[0] + size) % size , (self[1] + offset[1] + size) % size]
        } else {
            return [self[0] + offset[0] , self[1] + offset[1]]
        }
    }
    func at(_ position: Position) -> Bool {
        return self[0] == position[0] && self[1] == position[1]
    }
    init(x: Int, y: Int) {
        self.init([x, y])
    }
    init(withRandomPosition: Void) {
        self.init([Int(arc4random_uniform(UInt32(size))), Int(arc4random_uniform(UInt32(size)))])
    }
}

struct Field {
    private let game: Game
    private var array: [[FieldObject?]] = Array<Array<FieldObject?>>()
    mutating func update() {
        for i in 0..<size {
            for j in 0..<size {
                self[Position(x: i, y: j)] = nil
            }
        }
        self[game.gem.position] = game.gem
        game.snake.forEach { snakeBody in
            self[snakeBody.position] = snakeBody
        }
        self[game.snake[0].position] = FieldObject.SnakeHead(position: game.snake[0].position)
    }
    subscript(position: Position) -> FieldObject? {
        get {
            return array[position[0]][position[1]]
        }
        set(fieldObject) {
            array[position[0]][position[1]] = fieldObject
        }
    }
    init(game: Game) {
        self.game = game
        for i in 0..<size {
            array.append(Array<FieldObject?>())
            for _ in 0..<size {
                array[i].append(nil)
            }
        }
    }
}
