import UIKit

class ChildViewController: UIViewController {
    var isFullScreen: Bool = false
    var dummyVC: PortraitBackViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        let childLabel = UILabel()
        childLabel.text = "ChildView"
        childLabel.textAlignment = .center
        view.addSubview(childLabel)
        childLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }

        let actionButton = UIButton()
        actionButton.setTitle("Act", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setTitleColor(.black, for: .highlighted)
        actionButton.backgroundColor = .darkGray
        actionButton.addTarget(self, action: #selector(didTapedActionButton(action:)), for: .touchUpInside)
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

        dummyVC = PortraitBackViewController(parent: self, top: self.view)
        // Do any additional setup after loading the view.
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch fromInterfaceOrientation {
        case .landscapeLeft, .landscapeRight:
            isFullScreen = false
        case .portrait, .portraitUpsideDown:
            isFullScreen = true
            break
        case .unknown:
            break
        @unknown default:
            break
        }
    }
    
    @objc func didTapedActionButton(action: UITapGestureRecognizer) {
        print("Tap: \(supportedInterfaceOrientations)")
        let orientation: UIDeviceOrientation
        if isFullScreen || UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            orientation = .portrait
            isFullScreen = false
        } else {
            let currentOrientation = UIDevice.current.orientation
            switch currentOrientation {
            case .landscapeLeft, .landscapeRight:
                orientation = currentOrientation
            case .portrait:
                orientation = .landscapeLeft
            default:
                orientation = .landscapeLeft
            }
            isFullScreen = true
            modalPresentationStyle = .fullScreen
        }
//        UIDevice.current.setValue(UIDeviceOrientation.unknown.rawValue, forKey: #keyPath(UIDevice.orientation))
        UIDevice.current.setValue(orientation.rawValue, forKey: #keyPath(UIDevice.orientation))
        UIViewController.attemptRotationToDeviceOrientation()
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    override var shouldAutorotate: Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
