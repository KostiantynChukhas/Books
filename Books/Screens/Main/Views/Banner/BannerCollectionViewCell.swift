//
//  BannerCollectionViewCell.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import UIKit
import Kingfisher

class BannerCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 16
    }
    
    func configure(with model: TopBannerSlide?, currentPage: Int, totalPageCount: Int) {
        pageControl.numberOfPages = totalPageCount
        pageControl.currentPage = currentPage
        guard let urlString = model?.cover, let url = URL(string: urlString) else { return }
        imgView.kf.setImage(with: url)
    }
    
}
