//
//  MainCollectionViewCell.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: Book) {

        imgView.layer.cornerRadius = 16
        descriptionLabel.text = model.name
        
        if let urlString = model.coverURL, let url = URL(string: urlString) {
            imgView.kf.setImage(with: url)
        }
        
    }

}
