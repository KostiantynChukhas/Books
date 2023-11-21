//
//  CaruselDetailCollectionViewCell.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 21.11.2023.
//

import UIKit
import Kingfisher

class CaruselDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = 16
    }
    
    func configure(with model: Book) {
        if let stringUrl = model.coverURL, let url = URL(string: stringUrl) {
            imgView.kf.setImage(with: url)
        }
        nameLabel.text = model.name
        descriptionLabel.text = model.author
    }

}
