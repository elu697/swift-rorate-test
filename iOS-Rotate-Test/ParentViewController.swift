import UIKit

class ParentViewController: UIViewController {

    let childVC = ChildViewController()
    let containerView = UIView()
    var backVC = ViewController()
    var snapView = UIImageView()
    var backWindow: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        addChild(childVC)
        childVC.didMove(toParent: self)
        if let childView = childVC.view {
            view.addSubview(childView)
            childView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(view.frame.width * 9 / 16)
            }
        }

        // Container
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(childVC.view.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        let parentLabel = UILabel()
        parentLabel.text = "ParentView"
        parentLabel.textAlignment = .center
        containerView.addSubview(parentLabel)
        parentLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }

        let dummyView = UIView()
        dummyView.backgroundColor = .red
        containerView.addSubview(dummyView)
        dummyView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(parentLabel.snp.bottom).offset(50)
            make.width.height.equalTo(50)
        }

        let dummyView2 = UIView()
        dummyView2.backgroundColor = .red
        containerView.addSubview(dummyView2)
        dummyView2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(parentLabel.snp.top).offset(-50)
            make.width.height.equalTo(50)
        }

        let dummyView3 = UIView()
        dummyView3.backgroundColor = .red
        containerView.addSubview(dummyView3)
        dummyView3.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(parentLabel.snp.left).offset(-50)
            make.width.height.equalTo(50)
        }

        let dummyView4 = UIView()
        dummyView4.backgroundColor = .red
        containerView.addSubview(dummyView4)
        dummyView4.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(parentLabel.snp.right).offset(50)
            make.width.height.equalTo(50)
        }

        view.bringSubviewToFront(childVC.view)
        backVC.view = snapView
        view.insertSubview(snapView, aboveSubview: containerView)
        snapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.view.insertSubview(backVC.view, aboveSubview: containerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let rotaton: CGFloat
        switch UIDevice.current.orientation {
        case .portrait:
            rotaton = 0
        case .landscapeLeft:
            rotaton = -CGFloat.pi * 0.5
        case .landscapeRight:
            rotaton = +CGFloat.pi * 0.5
        default:
            rotaton = 0
        }

        if size.width > size.height {
            self.beginIgnoringInteractionEvents(parent: view)
            self.containerView.isHidden = true
            snapView.isHidden = false
        } else {
            backVC.view.isHidden = false
        }

        coordinator.animate(alongsideTransition: { trans in
            self.snapView.transform = .init(rotationAngle: CGFloat(rotaton))
            self.snapView.frame = self.view.frame
        }) { (comp) in
            if size.width > size.height {
//                 self.containerView.isHidden = true
            } else {
                self.containerView.isHidden = false
                self.endIgnoringInteractionEvents()
            }
        }

        UIView.animate(withDuration: 0.3) {
            if size.width > size.height {
//                self.containerView.alpha = 0
                if let childView = self.childVC.view {
                    childView.snp.updateConstraints { (update) in
                        update.height.equalTo(size.height)
                    }
                }
            } else {
//                self.containerView.alpha = 1
                if let childView = self.childVC.view {
                    childView.snp.updateConstraints { (update) in
                        update.height.equalTo((size.width) * 9 / 16)
                    }
                }
            }
        }
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("Rotate")

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

    func beginIgnoringInteractionEvents(parent view: UIView) {
        snapView.image = view.getSnapShot(windowFrame: view.frame, outFrame: childVC.view.frame)
        snapView.isHidden = false

//        self.view.setSnapShotView(topView: view)
    }

    func endIgnoringInteractionEvents() {
//        self.view.unsetSnapShotView()
        snapView.isHidden = true
    }
}

extension UIView {
    func getSnapShot(windowFrame: CGRect, outFrame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(windowFrame.size, false, 0.0)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return .init() }

        layer.render(in: context)
        //要らない領域を潰す
        context.setFillColor(UIColor.black.cgColor)
        context.fill(outFrame)

        guard let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return .init() }

        UIGraphicsEndImageContext()

        return capturedImage
    }

    func setSnapShotView(topView: UIView) {
        let snapShot = getSnapShot(windowFrame: self.frame,
                                   outFrame: topView.frame)

        if !self.subviews.contains(viewWithTag(self.hash) ?? .init()) {
            let snapShotImageView = UIImageView(image: snapShot)
            snapShotImageView.viewWithTag(self.hash)
            addSubview(snapShotImageView)
            NSLayoutConstraint.activate([
                snapShotImageView.topAnchor.constraint(equalTo: topAnchor),
                snapShotImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                snapShotImageView.leftAnchor.constraint(equalTo: leftAnchor),
                snapShotImageView.rightAnchor.constraint(equalTo: rightAnchor)
                ])
        } else {
            (self.viewWithTag(self.hash) as? UIImageView)?.image = snapShot
        }
        self.viewWithTag(self.hash)?.isHidden = false
    }

    func unsetSnapShotView() {
        self.viewWithTag(self.hash)?.isHidden = true
    }

}
