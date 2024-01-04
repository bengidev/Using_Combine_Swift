//
//  HomeViewController.swift
//  Simple Publisher Wrapper
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import Combine
import CoreLocation
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    // MARK: Properties
    private var homeView = HomeView()
    private var cancellableSet: Set<AnyCancellable> = []
    private let locationManager = LocationHeadingProxyManager()
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("awakeFromNib() has not been implemented")
    }

    // MARK: Lifecycles
    override func loadView() {
        super.loadView()
        
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Request authorization for the corelocation data
        //
        self.updatePermissionsStatus()
        
        let _ = locationManager
            .publisher
            .print("headingSubscriber")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("headingSubscriber completion: ", String(describing: completion))
            } receiveValue: { [weak self] someValue in // 5
                self?.homeView.setOneTextFieldText(with: String(someValue.trueHeading))
            }
            .store(in: &cancellableSet)
    }

    // MARK: Functionalities
    private func setupViews() -> Void {
        navigationController?.navigationBar.topItem?.title = "Simple Publisher Wrapper"
        
        homeView.setOneSwitchHandler(action: didChangeOneSwitch(_:))
        homeView.setOneButtonHandler(action: didTapOneButton)
        view = homeView
    }
    
    private func didChangeOneSwitch(_ isOn: Bool) -> Void {
        switch isOn {
        case true:
            self.locationManager.enable() // 4
            print("Enabling heading tracking")
        case false:
            self.locationManager.disable()
            print("Disabling heading tracking")
        }
    }
    
    private func didTapOneButton() -> Void {
        print("requesting corelocation permission")
        
        let _ = Future<Int, Never> { [weak self] promise in // 1
            self?.locationManager.manager.requestWhenInUseAuthorization()
            return promise(.success(1))
        }
            .delay(for: 5.0, scheduler: DispatchQueue.global(qos: .background)) // 2
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("updating corelocation permission label")
                self?.updatePermissionsStatus() // 3
            }
            .store(in: &cancellableSet)
    }
    
    private func updatePermissionsStatus() -> Void {
        let x = CLLocationManager.authorizationStatus()
        switch x {
        case .notDetermined:
            homeView.setTwoTextFieldText(with: "notDetermined")
        case .restricted:
            homeView.setTwoTextFieldText(with: "restricted")
        case .denied:
            homeView.setTwoTextFieldText(with: "denied")
        case .authorizedAlways:
            homeView.setTwoTextFieldText(with: "authorizedAlways")
        case .authorizedWhenInUse:
            homeView.setTwoTextFieldText(with: "authorizedWhenInUse")
        @unknown default:
            homeView.setTwoTextFieldText(with: "unknown default")
        }
    }
}

/// 1. One of the quirks of CoreLocation is the requirement to ask for permission from the user
///     to access the data. The API provided to initiate this request returns immediately,
///     but provides no detail if the user allowed or denied the request. The CLLocationManager class 
///     includes the information, and exposes it as a class method when you want to retrieve it,
///     but there is no information provided to know when, or if, the user has responded to the request.
///     Since the operation doesn’t provide any return, we provide an integer as the pipeline data,
///     primarily to represent that the request has been made.
/// 2. Since there isn’t a clear way to judge when the user will grant permission, but the permission
///     is persistent, we simply use a delay operator before attempting to retrieve the data.
///     This use simply delays the propagation of the value for two seconds.
/// 3. After that delay, we invoke the class method and attempt to update information in the interface
///     with the results of the current provided status.
/// 4. Since CoreLocation requires methods to be explicitly enabled or disabled to provide the data,
///     this connects a UISwitch toggle IBAction to the methods exposed on our publisher proxy.
/// 5. The heading data is received in this sink subscriber, where in this example we write it to a text label.
///

#if DEBUG
@available(iOS 13, *)
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview(HomeViewController())
    }
}
#endif
