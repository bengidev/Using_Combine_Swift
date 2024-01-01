//: A UIKit based Playground for presenting user interface
  
/// Creating Subscriber With Assign
///

import Combine
import UIKit
import PlaygroundSupport

class LoremIpsum {
    var descriptionHandler: ((String) -> Void)?
    
    var description: String = "" {
        didSet {
            print("description was set to: \(description)", terminator: "; ")
            descriptionHandler?(description)
        }
    }
}

final class MyViewController : UIViewController {
    // MARK: Properties
    private var loremIpsum: LoremIpsum = .init()
    
    // MARK: View Components
    private lazy var baseView: UIView = {
        let vw = UIView(frame: .zero)
        vw.backgroundColor = .white
        
        return vw
    }()
    
    private lazy var valueLabel: UITextField = {
        let lb = UITextField(frame: .zero)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lb.font = .preferredFont(forTextStyle: .subheadline)
        lb.adjustsFontForContentSizeCategory = true
        lb.adjustsFontSizeToFitWidth = true
        lb.placeholder = "Lorem Ipsum"
        lb.borderStyle = .roundedRect
        
        return lb
    }()

    
    private lazy var addMoreButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Add More", for: .normal)
        bt.setImage(.init(systemName: "plus"), for: .normal)
        bt.layer.cornerRadius = 10.0
        bt.layer.shadowOpacity = 0.1
        bt.layer.shadowRadius = 5.0
        bt.backgroundColor = .systemGray6
        bt.addTarget(
            self,
            action: #selector(self.didTapAddMoreButton(_:)),
            for: .primaryActionTriggered
        )

        return bt
    }()
    
    // MARK: Lifecycles
    override func loadView() {
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loremIpsum.descriptionHandler = { [weak self] description in
            self?.valueLabel.text = description
        }
    }
    
    // MARK: Functionalities
    private func setupViews() -> Void {
        view = baseView
        
        baseView.addSubview(valueLabel)
        baseView.addSubview(addMoreButton)
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: -140.0),
            valueLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3),
            valueLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.2),
        ])
        
        NSLayoutConstraint.activate([
            addMoreButton.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 20.0),
            addMoreButton.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor),
            addMoreButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12),
            addMoreButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.03),
        ])
    }
    
    @objc
    private func didTapAddMoreButton(_ sender: UIButton) -> Void {
        let texts: [String?] = ["LoremIpsum", "TorumDiroth", "LavorumSirotum"]
        
        let cancellablePipeline = texts // 1
            .publisher
            .receive(on: RunLoop.main) // 2
            .assign(to: \.text, on: valueLabel) // 3
        
        cancellablePipeline.cancel() // 4
    }
    
    /// 1. .assign is typically chained onto a publisher when you create it, and the return value is cancellable.
    /// 2. If .assign is being used to update a user interface element, you need to make sure that
    ///     it is being updated on the main thread. This call makes sure the subscriber is received on the main thread.
    /// 3. Assign references the property being updated using a key path, and a reference to the object being updated.
    /// 4. At any time you can cancel to terminate and invalidate pipelines with cancel(). Frequently, you cancel
    ///     the pipelines when you deactivate the objects (such as a viewController) that are
    ///     getting updated from the pipeline.
    ///
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
//

