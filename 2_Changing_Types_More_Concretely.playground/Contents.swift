import Cocoa
import Combine

var greeting = "Hello, playground"

// Changing Types More Concretely
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
