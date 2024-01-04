//
//  LocationHeadingProxyManager.swift
//  Simple Publisher Wrapper
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import Combine
import CoreLocation
import Foundation

final class LocationHeadingProxyManager: NSObject {
    private(set) var manager: CLLocationManager // 1
    private(set) var publisher: AnyPublisher<CLHeading, Error> // 3
    
    private let headingPublisher: PassthroughSubject<CLHeading, Error> // 2
    
    override init() {
        manager = CLLocationManager()
        headingPublisher = PassthroughSubject<CLHeading, Error>()
        publisher = headingPublisher.eraseToAnyPublisher()
        
        super.init()
        manager.delegate = self // 4
    }
    
    func enable() -> Void {
        manager.startUpdatingHeading() // 5
    }
    
    func disable() -> Void {
        manager.stopUpdatingHeading()
    }
}

extension LocationHeadingProxyManager: CLLocationManagerDelegate {
    /*
     *  locationManager:didUpdateHeading:
     *
     *  Discussion:
     *    Invoked when a new heading is available.
     */
    func locationManager(_: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingPublisher.send(newHeading) // 6
    }
    
    /*
     *  locationManager:didFailWithError:
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        headingPublisher.send(completion: .failure(error)) // 7
    }
}

/// 1. CLLocationManager is the heart of what is being wrapped, part of CoreLocation. Because it has additional methods
///     that need to be called for using the framework, I exposed it as a public read-only property.
///     This is useful for requesting user permission to use the location API,
///     which the framework exposes as a method on CLLocationManager.
/// 2. A private instance of PassthroughSubject with the data type we want to publish
///     provides our inside-the-class access to forward data.
/// 3. A public property publisher exposes the publisher from that subject for external subscriptions.
/// 4. The heart of this works by assigning this class as the delegate to the CLLocationManager instance,
///     which is set up at the tail end of initialization.
/// 5. The CoreLocation API doesn’t immediately start sending information. There are methods that need to be called
///     to start (and stop) the data flow, and these are wrapped and exposed on this proxy object. Most publishers are
///     set up to subscribe and drive consumption based on subscription, so this is a bit out of the norm
///     for how a publisher starts generating data.
/// 6. With the delegate defined and the CLLocationManager activated, the data will be provided via callbacks
///     defined on the CLLocationManagerDelegate. We implement the callbacks we want for this wrapped object,
///     and within them we use passthroughSubject .send() to forward the information to any existing subscribers.
/// 7. While not strictly required, the delegate provided an Error reporting callback, so we included that as an example
///     of forwarding an error through passthroughSubject.
///     
