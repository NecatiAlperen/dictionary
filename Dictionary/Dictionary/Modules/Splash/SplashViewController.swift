//
//  SplashViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import UIKit
import Lottie


protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
}



final class SplashViewController: BaseViewController {
    
    var presenter: SplashPresenterProtocol!
    private var animationView : LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.viewDidAppear()
        setupAnimation()
    }
    
    func setupAnimation() {
        animationView = .init(name: "dict")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        view.addSubview(animationView!)
        animationView!.play()
    }
    
    
    
}

extension SplashViewController : SplashViewControllerProtocol {
    
    func noInternetConnection() {
        showAlert(
            with: "Error",
            message: "No internet connection, please check your connection"
        )
    }
    
}
