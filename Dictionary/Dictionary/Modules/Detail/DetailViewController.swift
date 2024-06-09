//
//  DetailViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import UIKit


protocol DetailViewControllerProtocol: AnyObject {
    func showDetails(_ details: [WordDetail])
}

final class DetailViewController: UIViewController {
    
    var presenter: DetailPresenterProtocol!
    var details: [WordDetail]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.viewDidLoad()
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func showDetails(_ details: [WordDetail]) {
        // shw detail
    }
}

