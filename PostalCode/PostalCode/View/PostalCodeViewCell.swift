//
//  PostalCodeViewCell.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 27/03/21.
//

import UIKit

final class PostalCodeViewCell: UITableViewCell {
    
    let postalCodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Postal Code"
        label.numberOfLines = 1
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false 
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func identifier() -> String {
        "PostalCodeCell"
    }
    
    func setupView() {
        addSubview(postalCodeLabel)
        
        postalCodeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        postalCodeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        postalCodeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        postalCodeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
}
