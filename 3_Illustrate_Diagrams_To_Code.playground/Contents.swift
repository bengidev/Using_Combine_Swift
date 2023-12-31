import Cocoa
import Combine

var greeting = "Hello, playground"

// Illustrate Diagrams To Code
//
let _ = Just(5) // 1
    .map { value -> String in // 2
        print("Value: \(value)")
        
        switch value {
        case _ where value < 1:
            return "none"
        case _ where value == 1:
            return "one"
        case _ where value == 2:
            return "couple"
        case _ where value == 3:
            return "few"
        case _ where value > 8:
            return "many"
        default:
            return "some"
        }
    }
    .sink { receivedValue in // 3
        print("The end result was \(receivedValue)")
    }

/// 1. The closure provided to the .map() function takes in an <Int> and transforms it into a <String>.
/// Since the failure type of <Never> is not changed, it is passed through
///
