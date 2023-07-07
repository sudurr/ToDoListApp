

import Foundation

struct DelayingTime {
    static let minTime = 2
    static let maxTime = 120
    static let factor = 1.5
    static let jitter = 0.05

    static func calculateNextDelay(from delay: Int) -> Int {
        var nextDelay = min(Double(delay) * factor, Double(maxTime))
        nextDelay += nextDelay * Double.random(in: 0 ... jitter)
        return Int(nextDelay)
    }

//    static func calculateNextDelay(_ currentDelay: Int) -> Int {
//        let delayAsDouble = Double(currentDelay)
//        let basicNextDelay = min(delayAsDouble * factor, Double(maxTime))
//        let jitterComponent = basicNextDelay * Double.random(in: 0...jitter)
//        let totalNextDelay = basicNextDelay + jitterComponent
//        return Int(totalNextDelay)
//    }
}
