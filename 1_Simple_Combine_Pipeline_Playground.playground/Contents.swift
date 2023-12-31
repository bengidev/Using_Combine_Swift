import Cocoa
import Combine

var greeting = "Hello, playground"

// A simple Combine pipeline
//
let _ = Just(5) // 1
    .map { value -> String in // 2
        // do something with the incoming value here
        print("The value result was \(value)")
        
        // and return a string
        return "a string"
    }
    .sink { receivedValue in // 3
        // sink is the subscriber and terminates the pipeline
        print("The end result was \(receivedValue)")
    }

