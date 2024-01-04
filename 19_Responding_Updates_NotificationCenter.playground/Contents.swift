import Cocoa
import Combine

var greeting = "Hello, playground"

/// Responding Updates NotificationCenter
///

/// Notifications flowing through NotificationCenter provide a common, central location for events within your application.
///
extension Notification.Name {
    static let myExampleNotification = Notification.Name("an-example-notification")
}





/// Notification names are structured, and based on Strings. Object references can be passed when a notification
/// is posted to the NotificationCenter, indicating which object sent the notification. Additionally,
/// Notifications may include a userInfo, which has a type of [AnyHashable : Any]?. This allows for arbitrary dictionaries,
/// either reference or value typed, to be included with a notification.
///
let myUserInfo = ["foo": "bar"]

let note = Notification(name: .myExampleNotification, userInfo: myUserInfo)
NotificationCenter.default.post(note)





/// An example of subscribing to AppKit generated notifications:
///
//let sub = NotificationCenter.default.publisher(for: NSControl.textDidChangeNotification, // 1
//                                               object: filterField) // 2
//    .map { ($0.object as! NSTextField).stringValue } // 3
//    .assign(to: \MyViewModel.filterString, on: myViewModel) // 4

/// 1. TextFields within AppKit generate a textDidChangeNotification when the values are updated.
/// 2. An AppKit application can frequently have a large number of text fields that may be changed. Including a reference
///     to the sending control can be used to filter to text changed notifications to which you are specifically interested in responding.
/// 3. The map operator can be used to get into the object references included with the notification, in this case
///     the .stringValue property of the text field that sent the notification, providing its updated value.
/// 4. The resulting string can be assigned using a writable KeyValue path.
///




/// An example of subscribing to your own notifications:
///

class ExampleViewModel: NSObject {
    var exampleValue: String = .init()
}

let exampleViewModel = ExampleViewModel()
var cancellableSet: Set<AnyCancellable> = []

extension Notification.Name {
    static let newExampleNotification = Notification.Name("new-example-notification")
}

// can't use the object parameter to filter on a value reference, only class references, but
// filtering on 'nil' only constrains to notification name, so value objects *can* be passed
// in the notification itself.
NotificationCenter.default.publisher(
    for: .newExampleNotification,
    object: exampleViewModel
)
.sink { receivedNotification in
    print("passed through: ", receivedNotification)
    
    // receivedNotification.name
    // receivedNotification.object - object sending the notification (sometimes nil)
    // receivedNotification.userInfo - often nil
}

NotificationCenter.default.post(
    name: .newExampleNotification,
    object: exampleViewModel,
    userInfo: ["testerKey": "testerValue"]
)



NotificationCenter.default.publisher(
    for: .newExampleNotification,
    object: nil
)
.sink { receivedNotification in
    print("passed through: ", receivedNotification)
    
    // receivedNotification.name
    // receivedNotification.object - object sending the notification (sometimes nil)
    // receivedNotification.userInfo - often nil
}

NotificationCenter.default.post(
    name: .newExampleNotification,
    object: "testerValue"
)
