//
//  ViewController.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 26/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let searchBar = UISearchBar()
    let repository: PostalCodeRepository 
    
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
        
        configureUI()
        repository.getPostalCode(completion: { (result) in
            switch result {
            case .success(let postalCode):
                print(postalCode)
                return postalCode
            case .failure(_):
                print("FAIL")
                return [PostalCode(cod_distrito: "", cod_concelho: "", cod_localidade: "", nome_localidade: "", cod_arteria: "", tipo_arteria: "", prep1: "", titulo_arteria: "", prep2: "", nome_arteria: "", local_arteria: "", troco: "", porta: "", cliente: "", num_cod_postal: "", ext_cod_postal: "", desig_postal: "")]
            }
        })
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
        searchBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255,
                                                 blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Search Postal Code"
        showSearchBarButton(shouldShow: true)
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
