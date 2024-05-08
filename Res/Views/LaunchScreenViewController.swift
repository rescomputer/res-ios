import UIKit

class LaunchScreenViewController: UIViewController {
    
    var dismissAction: () -> Void = {}
    
    private let animationDuration: TimeInterval = 1.0
    private let dismissDelay: TimeInterval = 0.5
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "flow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.0
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        // if traitCollection.userInterfaceStyle == .dark {
        //     view.backgroundColor = .black
        //     logoImageView.tintColor = .white
        // } else {
        //     view.backgroundColor = .white
        //     logoImageView.tintColor = .black
        // }
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateLaunchScreen()
    }
    
    private func animateLaunchScreen() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.logoImageView.alpha = 1.0
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.dismissDelay) {
                self.dismissLaunchScreen()
            }
        }
    }
    
    private func dismissLaunchScreen() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }) { _ in
            self.dismiss(animated: false) {
                self.dismissAction()
            }
        }
    }
}

#Preview {
    LaunchScreenViewController()
}
