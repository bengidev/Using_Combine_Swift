//
//  ViewController.swift
//  Sequencing Asynchronous Operations
//
//  Created by Bambang Tri Rahmat Doni on 01/01/24.
//

import Combine
import SwiftUI
import UIKit

extension UIScreen {
    static var width: CGFloat {
        return self.main.bounds.width
    }
    
    static var height: CGFloat {
        return self.main.bounds.height
    }
}

final class ViewController: UIViewController {
    // MARK: Properties
    private var cancellable: AnyCancellable?
    private var coordinatedPipeline: AnyPublisher<Bool, Error>?
    
    // MARK: View Components
    private lazy var containerView: UIView = {
        let vw = UIView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.backgroundColor = .systemGray2
        
        return vw
    }()
    
    private lazy var oneVStackView: UIStackView = {
        let vw = UIStackView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.axis = .vertical
        vw.distribution = .fillProportionally
        vw.alignment = .center
        vw.spacing = 10.0
        
        return vw
    }()
    
    private lazy var startButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Start", for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.shadowRadius = 3.0
        bt.backgroundColor = .systemGray6
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        bt.addTarget(
            self,
            action: #selector(didTapStartButton),
            for: .primaryActionTriggered
        )
        
        return bt
    }()
    
    private lazy var stepOneButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Step One", for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.shadowRadius = 3.0
        bt.backgroundColor = .systemGray6
        bt.tintColor = .white
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return bt
    }()
    
    private lazy var stepTwoButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Step Two", for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.shadowRadius = 3.0
        bt.backgroundColor = .systemGray6
        bt.tintColor = .white
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return bt
    }()
    
    private lazy var stepThreeButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Step Three", for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.shadowRadius = 3.0
        bt.backgroundColor = .systemGray6
        bt.tintColor = .white
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return bt
    }()
    
    private lazy var stepFourButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Step Four", for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.shadowRadius = 3.0
        bt.backgroundColor = .systemGray6
        bt.tintColor = .white
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return bt
    }()
    
    private lazy var stepFiveButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Step Five", for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.shadowRadius = 3.0
        bt.backgroundColor = .systemGray6
        bt.tintColor = .white
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return bt
    }()
    
    private lazy var stepSixButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Step Six", for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.shadowRadius = 3.0
        bt.backgroundColor = .systemGray6
        bt.tintColor = .white
        bt.backgroundColor = .systemBlue
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return bt
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let vw = UIActivityIndicatorView(style: .large)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.hidesWhenStopped = false
        vw.stopAnimating()
        
        return vw
    }()
    
    // MARK: Lifecycles
    override func loadView() {
        super.loadView()
        
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coordinatedPipeline = createFuturePublisher(button: stepOneButton) // 7
            .flatMap { [weak self] value -> AnyPublisher<Bool, Error> in
                guard let self else { return PassthroughSubject().eraseToAnyPublisher() }
                
                let stepTwo = createFuturePublisher(button: self.stepTwoButton)
                let stepThree = createFuturePublisher(button: self.stepThreeButton)
                let stepFour = createFuturePublisher(button: self.stepFourButton)
                
                return Publishers.Zip3(stepTwo, stepThree, stepFour)
                    .map { _ -> Bool in return true }
                    .eraseToAnyPublisher()
            }
            .flatMap { _ in
                return self.createFuturePublisher(button: self.stepFiveButton)
            }
            .flatMap { _ in
                return self.createFuturePublisher(button: self.stepSixButton)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: Functionalities
    private func setupViews() -> Void {
        navigationController?.title = "Sequencing Asynchronous Operations"
        view.backgroundColor = .systemGray2
        
        view.addSubview(containerView)
        
        containerView.addSubview(oneVStackView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        oneVStackView.addArrangedSubview(stepOneButton)
        oneVStackView.addArrangedSubview(stepTwoButton)
        oneVStackView.addArrangedSubview(stepThreeButton)
        oneVStackView.addArrangedSubview(stepFourButton)
        oneVStackView.addArrangedSubview(stepFiveButton)
        oneVStackView.addArrangedSubview(stepSixButton)
        oneVStackView.setCustomSpacing(UIScreen.height * 0.05, after: stepSixButton)
        oneVStackView.addArrangedSubview(activityIndicator)
        oneVStackView.setCustomSpacing(UIScreen.height * 0.05, after: activityIndicator)
        oneVStackView.addArrangedSubview(startButton)
        NSLayoutConstraint.activate([
            oneVStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oneVStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stepOneButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.3),
            stepOneButton.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
        
        NSLayoutConstraint.activate([
            stepTwoButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.3),
            stepTwoButton.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
        
        NSLayoutConstraint.activate([
            stepThreeButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.3),
            stepThreeButton.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
        
        NSLayoutConstraint.activate([
            stepFourButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.3),
            stepFourButton.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
        
        NSLayoutConstraint.activate([
            stepFiveButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.3),
            stepFiveButton.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
        
        NSLayoutConstraint.activate([
            stepSixButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.3),
            stepSixButton.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.2),
            activityIndicator.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 0.2),
            startButton.heightAnchor.constraint(equalToConstant: UIScreen.height * 0.06),
        ])
    }
    
    private func runPipelineProcess() -> Void {
        if cancellable != nil { // 1
            print("Cancelling existing run")
            
            cancellable?.cancel()
            activityIndicator.stopAnimating()
        }
        
        print("Resetting all the processes")
        resetAllProcess() // 2
        
        // Driving it by attaching it to .sink
        activityIndicator.startAnimating() // 3
        
        print("Attaching a new sink to start things going")
        cancellable = coordinatedPipeline? // 4
            .print()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                
                print(".sink() received the completion: ", String(describing: completion))
                self.activityIndicator.stopAnimating()
            }, receiveValue: { someValue in
                print(".sink() received value: ", someValue)
            })
    }
    
    private func resetAllProcess() -> Void {
        for button in [
            stepOneButton,
            stepTwoButton,
            stepThreeButton,
            stepFourButton,
            stepFiveButton,
            stepSixButton
        ] {
            button.backgroundColor = .systemGray6
        }
        
        activityIndicator.stopAnimating()
    }
    
    /// Creates and returns pipeline that uses a Future to wrap randomAsyncAPI
    /// and then updates a UIButton to represent the completion of the async
    /// work before returning a boolean True.
    /// - Parameter button: button to be updated
    ///
    private func createFuturePublisher(button: UIButton) -> AnyPublisher<Bool, Error> { // 5
        return Future<Bool, Error> { [weak self] promise in
            guard let self else { return }
            
            self.randomAsyncAPI { result, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(result))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        // So that we can update UI elements to show the "completion" of this step.
        //
        .map { inValue -> Bool in // 6
            // Intentionally side effecting here to show progress of pipeline
            //
            self.markStepDone(button: button)
            return inValue
        }
        .eraseToAnyPublisher()
    }
    
    // This emulates an async API call with a completion callback,
    // it does nothing other than wait and ultimately return with a boolean value.
    //
    private func randomAsyncAPI(completion: (@escaping (Bool, Error?) -> Void)) -> Void {
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: .random(in: 1...5))
            completion(true, nil)
        }
    }
    
    /// Highlights a button and changes the background color to green
    /// - Parameter button: reference to button being updated
    ///
    private func markStepDone(button: UIButton) -> Void {
        button.tintColor = .white
        button.backgroundColor = .systemGreen
    }
    
    @objc
    private func didTapStartButton(_ sender: UIButton) -> Void {
        runPipelineProcess()
    }
}

#if DEBUG
@available(iOS 13, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview(ViewController())
            .edgesIgnoringSafeArea(.all)
    }
}
#endif

