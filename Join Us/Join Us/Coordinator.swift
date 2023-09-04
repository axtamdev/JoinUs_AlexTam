//
//  Coordinator.swift
//  Join Us
//
//  Created by Alex Tam on 2/9/2023.
//

import UIKit

class Coordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let interactor = JoinUsInteractor()
        let presenter = JoinUsPresenter()
        let viewController = JoinUsViewController()
        
        presenter.view = viewController
        viewController.interactor = interactor
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
