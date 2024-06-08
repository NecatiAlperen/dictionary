//
//  BaseViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import UIKit

 class BaseViewController: UIViewController, LoadingShowable {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel))
        present(alert, animated: true)
        
    }

    

}
