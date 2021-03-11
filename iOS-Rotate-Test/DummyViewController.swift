//
//  DummyViewController.swift
//  iOS-Rotate-Test
//
//  Created by 平山 智己 on 2021/03/10.
//

import UIKit

/// TopのVCに追加
/// let dummyVC: DummyViewController?
/// dummyVC = DummyViewController(parent: self, top: self.view)
class DummyViewController: UIViewController {
    private let parentVC: UIViewController
    private let topView: UIView
    private let snapShotView: UIImageView = UIImageView()

    private var isSnap = false

    init(parent: UIViewController, top: UIView) {
        self.parentVC = parent.parent ?? parent
        self.topView = top
        super.init(nibName: nil, bundle: nil)
        self.view = snapShotView
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = .brown
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.parentVC.addChild(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let rotation: CGFloat
        switch UIDevice.current.orientation {
        case .portrait:
            rotation = 0
            view.isHidden = false
        case .landscapeLeft:
            if !(view.bounds.width > view.bounds.height) { setSnap() }
            rotation = -CGFloat.init(Double.pi * 0.5)
            view.isHidden = true
        case .landscapeRight:
            if !(view.bounds.width > view.bounds.height) { setSnap() }
            rotation = CGFloat.init(Double.pi * 0.5)
            view.isHidden = true

        default:
            rotation = 0
        }

        coordinator.animate(alongsideTransition: { [weak self] trans in
            self?.view.frame = trans.containerView.bounds
            self?.view.transform = .init(rotationAngle: CGFloat(rotation))
        }) { [weak self] comp in
            if !(size.width > size.height) {
                // affin変換のcompleateのタイミングがシビアで挙動がおかしくなるので遅延
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self?.view.isHidden = true
                    self?.removeSnap()
                }
            }
        }
    }

    func setSnap() {
        snapShotView.image = parentVC.view.getSnapShot(windowFrame: view.frame, outFrame: topView.frame)
        parentVC.view.insertSubview(view, belowSubview: topView)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parentVC.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor),
            view.leftAnchor.constraint(equalTo: parentVC.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: parentVC.view.rightAnchor)
            ])
    }

    func removeSnap() {
        view.removeFromSuperview()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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

        guard let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return .init()
        }

        UIGraphicsEndImageContext()

        return capturedImage
    }
}
