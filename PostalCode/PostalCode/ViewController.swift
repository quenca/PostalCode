//
//  ViewController.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 26/03/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    let searchBar = UISearchBar()
    private let repository: PostalCodeRepository
    private var postalCodeList: [PostalCode] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = 64
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    @objc public convenience init() {
        self.init(repository: ContentProvider())
    }
    
    init(repository: PostalCodeRepository) {
        
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostalCodeViewCell.self, forCellReuseIdentifier: PostalCodeViewCell.identifier())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        startLoading()
        configureUI()
        resquestAPIPostalCode()
    }
    
    // MARK: - Selectors
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        searchBar.sizeToFit()
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255,
                                                                   blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Search Postal Code"
        showSearchBarButton(shouldShow: true)
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    func resquestAPIPostalCode() {
    repository.getPostalCode(completion: { (result) in
        switch result {
        case .success(let postalCode):
            self.postalCodeList = postalCode
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.dismiss(animated: false, completion: nil)
            }
            return postalCode
        case .failure(_):
            print("FAIL")
            self.dismiss(animated: false, completion: nil)
            return [PostalCode(nome_localidade: "", num_cod_postal: "")]
        }
    })
    }
    
    func startLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postalCodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        PostalCodeViewCell.identifier(), for: indexPath) as? PostalCodeViewCell else {
            return UITableViewCell()
            
        }
        
        let postalCode = postalCodeList[indexPath.row]
        cell.setup(postalCode: postalCode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did begin..")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did end..")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
    }
}
