//
//  HeaderCollectionReusableView.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
}
