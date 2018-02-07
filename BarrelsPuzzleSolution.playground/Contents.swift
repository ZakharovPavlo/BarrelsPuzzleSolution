//: Playground - noun: a place where people can play

import UIKit

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
    
    func splitIfConditionMet(splitBy: Int, condition: Bool) -> [Element] {
        let result = self.chunked(by: splitBy)
        return condition ? result[0] : result[1]
    }
}

struct Barrel: CustomStringConvertible {
    var isPoisoned = false
    
    var index: Int
    
    var description: String {
        return "\(index)"
    }
}

struct Slave {
    var isAlive = true
    var orderNumber: Int
    
    mutating func drink(barrel: Barrel) {
        if barrel.isPoisoned {
            isAlive = false
            debugPrint("\(orderNumber) Dead")
        }
    }
}

//Set Up

var barrels = [Barrel]()
var slaves = [Slave]()

for index in 0...63 {
    barrels.append(Barrel(isPoisoned: false, index: index))
}

for index in 0...5 {
    slaves.append(Slave(isAlive: true, orderNumber: index))
}

let randomNumber = Int(arc4random() % 63)

debugPrint("\(randomNumber) Barrel is poisoned")

barrels[randomNumber].isPoisoned = true

let barrelsForFirstSlave = barrels.chunked(by: 32)[0]
let barrelsForSecondSlave = barrels.chunked(by: 16).enumerated().filter({ $0.offset % 2 == 0 }).flatMap({$0.element})
let barrelsForThirdSlave = barrels.chunked(by: 8).enumerated().filter({ $0.offset % 2 == 0 }).flatMap({$0.element})
let barrelsForFourthSlave = barrels.chunked(by: 4).enumerated().filter({ $0.offset % 2 == 0 }).flatMap({$0.element})
let barrelsForFifthSlave = barrels.chunked(by: 2).enumerated().filter({ $0.offset % 2 == 0 }).flatMap({$0.element})
let barrelsForSixthSlave = barrels.enumerated().filter({ $0.offset % 2 == 0 }).flatMap({$0.element})

debugPrint("Overal: \(barrels.count)")

// Consume barrels

barrelsForFirstSlave.forEach({slaves[0].drink(barrel: $0)})
barrelsForSecondSlave.forEach({slaves[1].drink(barrel: $0)})
barrelsForThirdSlave.forEach({slaves[2].drink(barrel: $0)})
barrelsForFourthSlave.forEach({slaves[3].drink(barrel: $0)})
barrelsForFifthSlave.forEach({slaves[4].drink(barrel: $0)})
barrelsForSixthSlave.forEach({slaves[5].drink(barrel: $0)})

//Check answer
var results = barrels
for slave in slaves {
    let isSlaveAlive = slaves[slave.orderNumber].isAlive
    debugPrint("Slave \(slave.orderNumber) is \(isSlaveAlive ? "alive" : "dead")")
    results = results.splitIfConditionMet(splitBy: results.count / 2, condition: !isSlaveAlive)
    debugPrint("Iteration \(slave.orderNumber): \(results)")
}

debugPrint("I assume that \(results[0].index) is poisoned")

assert(results[0].index == randomNumber)

debugPrint("Ліля - сонце 😍")










