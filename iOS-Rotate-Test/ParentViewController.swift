import UIKit

class ParentViewController: UIViewController {

    let childVC = ChildViewController()
    let containerView = UIView()
    var backVC = ViewController()
    var snapView = UIImageView()
    var backWindow: UIWindow?

    var dummyVC: DummyViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addChild(childVC)
        childVC.didMove(toParent: self)
        if let childView = childVC.view {
            view.addSubview(childView)
            childView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(view.bounds.width * 9 / 16)
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

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print(fromInterfaceOrientation)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        snapView.alpha = 0
        let rotaton: CGFloat
        switch UIDevice.current.orientation {
        case .portrait:
            rotaton = 0
        case .landscapeLeft:
            rotaton = -CGFloat.init(Double.pi * 0.5)
            if !(snapView.bounds.width > snapView.bounds.height) {
                self.beginIgnoringInteractionEvents(parent: view)
            }
        case .landscapeRight:
            rotaton = CGFloat.init(Double.pi * 0.5)
            if !(snapView.bounds.width > snapView.bounds.height) {
                self.beginIgnoringInteractionEvents(parent: view)
            }
        default:
            rotaton = 0
        }
//        childVC.view.alpha = 0.4
        if size.width > size.height {
            self.containerView.isHidden = true
            self.snapView.isHidden = true
        } else {
            backVC.view.isHidden = false
        }

        coordinator.animate(alongsideTransition: { trans in
            self.snapView.frame = trans.containerView.bounds
            self.snapView.transform = .init(rotationAngle: CGFloat(rotaton))
            if size.width > size.height {
                if let childView = self.childVC.view {
                    childView.snp.updateConstraints { (update) in
                        update.height.equalTo(size.height)
                    }
                }
            } else {
                if let childView = self.childVC.view {
                    childView.snp.updateConstraints { (update) in
                        update.height.equalTo((size.width) * 9 / 16)
                    }
                }
            }
        }) { (comp) in
            if !(size.width > size.height) {
                // affin変換のcompleateのタイミングがシビアで挙動がおかしくなるので
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.containerView.isHidden = false
                    self.backVC.view.isHidden = true
                }
            }
        }
    }


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    override var shouldAutorotate: Bool {
        return true
    }

    func beginIgnoringInteractionEvents(parent view: UIView) {
        snapView.image = view.getSnapShot(windowFrame: view.frame, outFrame: childVC.view.frame)
    }
}
