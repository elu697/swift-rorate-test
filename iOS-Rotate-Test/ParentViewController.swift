import UIKit

class ParentViewController: UIViewController {

    let childVC = ChildViewController()
    let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

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
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //ここだとhiddenほぼ意味ない
        if size.width > size.height {
            self.containerView.isHidden = true
        } else {
            self.containerView.isHidden = false
        }
        coordinator.animate(alongsideTransition: { [weak self] trans in
            if size.width > size.height {
                if let childView = self?.childVC.view {
                    childView.snp.updateConstraints { (update) in
                        update.height.equalTo(size.height)
                    }
                }
            } else {
                if let childView = self?.childVC.view {
                    childView.snp.updateConstraints { (update) in
                        update.height.equalTo((self?.view.frame.width ?? 0) * 9/16)
                    }
                }
            }
        }, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
