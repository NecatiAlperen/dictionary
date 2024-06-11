//
//  HomeViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showError(_ message: String)
    func showRecentSearches(_ searches: [String])
}

final class HomeViewController: BaseViewController {

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search.."
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var recentSearchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recent Search"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        return imageView
    }()

    private lazy var recentSearchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recentSearchLabel, arrowImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private lazy var recentSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        return tableView
    }()
    
    private var searchButtonBottomConstraint: NSLayoutConstraint!
    private var recentSearchTableHeightConstraint: NSLayoutConstraint!
    private var recentSearches: [String] = []
    
    var presenter: HomePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        self.hideKeyboardWhenTappedAround()

        presenter.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(recentSearchClicked))
        recentSearchStackView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func recentSearchClicked() {
        recentSearchTableView.isHidden.toggle()
        recentSearchTableHeightConstraint.constant = recentSearchTableView.isHidden ? 0 : 220
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        if !recentSearchTableView.isHidden {
            presenter.fetchRecentSearches()
        }
    }
    
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        view.addSubview(recentSearchStackView)
        view.addSubview(recentSearchTableView)
        
        let screenWidth = UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            
            recentSearchStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            recentSearchStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recentSearchStackView.widthAnchor.constraint(equalToConstant: screenWidth * 0.8),
            recentSearchStackView.heightAnchor.constraint(equalToConstant: 44),
            
            recentSearchTableView.topAnchor.constraint(equalTo: recentSearchStackView.bottomAnchor, constant: 8),
            recentSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recentSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
        
        recentSearchTableHeightConstraint = recentSearchTableView.heightAnchor.constraint(equalToConstant: 0)
        recentSearchTableHeightConstraint.isActive = true
        
        searchButtonBottomConstraint = searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        searchButtonBottomConstraint.isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            searchButtonBottomConstraint.constant = -keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        searchButtonBottomConstraint.constant = -20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func didTapSearchButton() {
        guard let query = searchBar.text, !query.isEmpty else { return }
        presenter.search(query: query)
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func showError(_ message: String) {
        showAlert(with: "Error", message: message)
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func showRecentSearches(_ searches: [String]) {
        self.recentSearches = searches
        recentSearchTableView.reloadData()
    }
}

extension HomeViewController: UISearchBarDelegate {
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }
        cell.configure(with: recentSearches[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchText = recentSearches[indexPath.row]
        searchBar.text = searchText
        didTapSearchButton()
    }
}




