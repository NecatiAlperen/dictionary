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
    func toggleRecentSearchTableView(isVisible: Bool)
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
    
    private lazy var noResultView: NoResultView = {
        let view = NoResultView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var searchButtonBottomConstraint: NSLayoutConstraint!
    private var recentSearchTableHeightConstraint: NSLayoutConstraint!
    
    var presenter: HomePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        self.hideKeyboardWhenTappedAround()
        presenter.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(recentSearchClicked))
        recentSearchStackView.addGestureRecognizer(tap)
        keyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchRecentSearches()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func recentSearchClicked() {
        presenter.toggleRecentSearches()
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(recentSearchStackView)
        view.addSubview(recentSearchTableView)
        view.addSubview(noResultView)
        view.addSubview(searchButton)
        
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
            
            noResultView.topAnchor.constraint(equalTo: recentSearchStackView.bottomAnchor, constant: 8),
            noResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            noResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            noResultView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        recentSearchTableHeightConstraint = recentSearchTableView.heightAnchor.constraint(equalToConstant: 0)
        recentSearchTableHeightConstraint.isActive = true
        
        searchButtonBottomConstraint = searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
        searchButtonBottomConstraint.constant = 0
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
        recentSearchTableView.reloadData()
        noResultView.isHidden = !searches.isEmpty
    }

    func toggleRecentSearchTableView(isVisible: Bool) {
        recentSearchTableView.isHidden = !isVisible
        recentSearchTableHeightConstraint.constant = isVisible ? 220 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRecentSearches()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }
        cell.configure(with: presenter.recentSearch(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectRecentSearch(at: indexPath.row)
    }
    
}


