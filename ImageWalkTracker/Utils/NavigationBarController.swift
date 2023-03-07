//
//  NavigationBarController.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import UIKit

class NavigationBarController: UIViewController {

    private (set) var embeddedViewController: UIViewController

    init(embeddedViewController: UIViewController) {
        self.embeddedViewController = embeddedViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not available from xib")
    }

    // MARK: - View lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = .white

        view.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.constrainToParentHorizontally()
        statusBarBackgroundView.pinTopToParent()
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: statusBarBackgroundView.bottomAnchor).isActive = true

        let navigationBar = UINavigationBar()
        view.addSubview(navigationBar)
        navigationBar.constrainToParentHorizontally()
        navigationBar.pinTopToBottom(of: statusBarBackgroundView)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .lightGray
        view.addSubview(dividerView)
        dividerView.constrainToParentHorizontally()
        dividerView.pinTopToBottom(of: navigationBar)
        dividerView.setupHeightConstraint(1)
        
        addChild(embeddedViewController)
        view.addSubview(embeddedViewController.view)
        embeddedViewController.view.constrainToParentHorizontally()
        embeddedViewController.view.pinTopToBottom(of: dividerView)
        embeddedViewController.view.pinBottomToParent()
        embeddedViewController.didMove(toParent: self)

        navigationBar.pushItem(embeddedViewController.navigationItem, animated: false)
        style(navigationBar: navigationBar)
    }

    private func style(navigationBar: UINavigationBar) {
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .white
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .systemBlue
    }
}
