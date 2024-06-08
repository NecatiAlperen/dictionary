//
//  SplashViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import UIKit


protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
}



final class SplashViewController: BaseViewController {

    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "splash screen"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var presenter: SplashPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        presenter.viewDidAppear()
    }
    
    func setupViews() {
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 200),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
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
