import UIKit

class ParentViewController: UIViewController {

    let childVC = ChildViewController()
    let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addChild(childVC)
        childVC.didMove(toParent: self)
        if let childView = childVC.view {
            view.addSubview(childView)
            childView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.3)
            }
        }

        // Container
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
        return false
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
